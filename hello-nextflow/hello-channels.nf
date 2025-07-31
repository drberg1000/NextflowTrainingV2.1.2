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
    training/hello-nextflow -> echo -e '"Hello Channels!"\n"Hola"\n"Bienvinedo"\n"Guten Morgen"\n' > greetings.csv
    training/hello-nextflow -> rm -r results/* ; nextflow run hello-channels.nf ; cat results/*
    */
    greeting_ch = Channel.fromPath(params.greeting)
                         .view {csv -> "Before splitCsv: $csv"}
                         .splitCsv()
                         .view {csv -> "After splitCsv: $csv"}
                         .map { item -> item[0] }
                         .view {csv -> "After map: $csv"}

    // emit a greeting
    sayHello(greeting_ch)

    // Expectation:
    /*
        No error about a missing file this time.
        Before Split == Path
        After Split == Values
        Something like a list of lists where the inner list has only one value and the outer list corresponds to each line.
        Results directory will have contents now.
    */

    // Outputs:
    /*
        Nextflow 25.04.6 is available - Please consider updating your version to it

        N E X T F L O W   ~  version 25.04.3

        Launching `hello-channels.nf` [condescending_lattes] DSL2 - revision: 639511b771

        executor >  local (2)
        executor >  local (4)
        executor >  local (4)
        [64/459efd] sayHello (4) | 4 of 4 ✔
        Before splitCsv: /workspaces/training/hello-nextflow/greetings.csv
        After splitCsv: ["Hello Channels!"]
        After splitCsv: ["Hola"]
        After splitCsv: ["Bienvinedo"]
        After splitCsv: ["Guten Morgen"]
        After map: "Hello Channels!"
        After map: "Hola"
        After map: "Bienvinedo"
        After map: "Guten Morgen"

        "Bienvinedo"
        "Guten Morgen"
        "Hello Channels!"
        "Hola"
        training/hello-nextflow ->
    */

    /* Review...
        As expected.
    */
}
