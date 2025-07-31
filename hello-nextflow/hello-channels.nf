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
params.greeting = "Hello, World!"
workflow {
    // Converts greetings_array is treated as a string instead of an array of strings
    // greetings_array = ['Hello Channels!', 'Hola', 'Bienvinedo']
    // greeting_ch = Channel.of(greetings_array)

    // Creates a sayHello Call for each string in parens
    // greeting_ch = Channel.of('Hello Channels!', 'Hola', 'Bienvinedo')

    // Shows the content of greeting_ch at each step.
    greetings_array = ['Hello Channels!', 'Hola', 'Bienvinedo', "Guten Morgen"]
    greeting_ch = Channel.of(greetings_array)
                         .view { greeting->"Before flatten: $greeting"}
                         .flatten()
                         .view { greeting->"After flatten: $greeting"}
    // emit a greeting
    sayHello(greeting_ch)
}
