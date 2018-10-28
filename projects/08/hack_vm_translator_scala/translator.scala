import java.io.File
import java.io.PrintWriter

import scala.io.Source

object Translator {
   def main(args: Array[String]) {
      val inputFile: String = "../ProgramFlow/BasicLoop/BasicLoop.vm"
      val outputFile: String = "../ProgramFlow/BasicLoop/BasicLoop.asm"

      val writer = new PrintWriter(new File(outputFile))

      Source.fromFile(inputFile).foreach {
        line => writer.write(line)
      }

      writer.close()
   }
}
