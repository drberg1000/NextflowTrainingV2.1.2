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
params.greeting = "greeting.csv"
workflow {
    // Running with: training/hello-nextflow -> rm -r results/* ; nextflow run hello-channels.nf ; cat results/*
    greeting_ch = Channel.fromPath(params.greeting)
                         .view {csv -> "Before splitCsv: $csv"}
                         .splitCsv()
                         .view {csv -> "After splitCsv: $csv"}


    // emit a greeting
    sayHello(greeting_ch)

    // Expect ??? The above isn't really consistent as we haven't created a file anyway.
    // Wondering what the error will be. How is a path generated from a string? Using CWD?

    // Outputs:
    /*
    Caused by:
        File `/workspaces/training/hello-nextflow/greeting.csv-output.txt` is outside the scope of the process work directory: /workspaces/training/hello-nextflow/work/92/9051b75b849b9412aaadb7f26f54f7


        Command executed:

        echo '/workspaces/training/hello-nextflow/greeting.csv' >> '/workspaces/training/hello-nextflow/greeting.csv-output.txt'
    */

    /* Review...
    Channel.fromPath prepended CWD to the string.
    Process sayHello just treated it as a string.
    */
}
