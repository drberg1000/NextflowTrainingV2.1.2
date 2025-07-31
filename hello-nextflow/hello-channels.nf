#!/usr/bin/env nextflow

/*
 * Use echo to print 'Hello World!' to a file
 */
process sayHello {

    publishDir 'results', mode: 'copy'

    input:
        val greeting

    output:
        path "$greeting-output.txt"

    script:
    """
    echo '$greeting' >> '$greeting-output.txt'
    """
}

/*
 * Pipeline parameters
 */
params.greeting = "greetings.csv"
workflow {
    // Running with:
    /*
    training/hello-nextflow -> echo '"Hello Channels!", "Hola", "Bienvinedo", "Guten Morgen"' > greetings.csv
    training/hello-nextflow -> rm -r results/* ; nextflow run hello-channels.nf ; cat results/*
    */
    greeting_ch = Channel.fromPath(params.greeting)
                         .view {csv -> "Before splitCsv: $csv"}
                         .splitCsv()
                         .view {csv -> "After splitCsv: $csv"}


    // emit a greeting
    sayHello(greeting_ch)

    // Expectation:
    /*
        No error about a missing file this time.
        Before Split == Path
        After Split == Values
    */

    // Outputs:
    /*
        ERROR ~ Error executing process > 'sayHello (1)'

        Caused by:
            Missing output file(s) `["Hello Channels!",  "Hola",  "Bienvinedo",  "Guten Morgen"]-output.txt` expected by process `sayHello (1)`
    */

    /* Review...
    Ah... back to roughtly where we were with .flatten() being needed.

    */
}
