#!/usr/bin/env nextflow

/*
 * Use echo to print 'Hello World!' to a file
 */
process sayHello {

    publishDir 'results', mode: 'copy'

    input:
        val greeting

    output:
        path "${greeting}-output.txt"

    script:
    """
    echo '$greeting' > '$greeting-output.txt'
    """
}

/*
 * Pipeline parameters
 */
params.greeting = 'greetings.csv'

workflow {
    // create a channel for inputs from a CSV file
    greeting_ch = Channel.fromPath(params.greeting)
                        .splitCsv()
                        .map { line -> line[0] }

    // emit a greeting
    sayHello(greeting_ch)
}

/* Run With...
/workspaces -> echo -e '"Hello Channels!"\n"Hola"\n"Bienvinedo"\n"Guten Morgen"\n' > greetings.csv
/workspaces -> cd /workspaces/DRB_Training ; rm -r results/* ; nextflow run hellow-nextflow/hello-channels.nf ; cat results/*
*/


/* Results...git 
DRB_Training -> cd /workspaces/DRB_Training ; rm -r results/* ; nextflow run hello-nextflow/hello-workflow.nf ; cat results/*
rm: cannot remove 'results/*': No such file or directory
Nextflow 25.04.6 is available - Please consider updating your version to it

 N E X T F L O W   ~  version 25.04.3

Launching `hello-nextflow/hello-workflow.nf` [compassionate_albattani] DSL2 - revision: b14d1df5ec

executor >  local (4)
[f8/1b003e] sayHello (4) | 4 of 4 ✔

"Bienvinedo"
"Guten Morgen"
"Hello Channels!"
"Hola"
DRB_Training -> 
*/
