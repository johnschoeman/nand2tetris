import java.io.File
import java.io.PrintWriter

import scala.io.Source

object Translator {
   def main(args: Array[String]) {
      val inputFile: String = "../ProgramFlow/BasicLoop/BasicLoop.vm"
      val outputFile: String = "../ProgramFlow/BasicLoop/BasicLoop.asm"

      val writer = new PrintWriter(new File(outputFile))

      Source
        .fromFile(inputFile)
        .getLines
        .map { line => appendNewLine(line) }
        .map { line => removeComments(line) }
        .map { line => removeWhiteSpace(line) }
        .foreach { line => {
          writer.write(line)
        }
      }

      writer.close()
   }

   def appendNewLine(line: String): String =
     s"$line\n"

   def removeComments(line: String): String = {
     val regex = "//.*".r
     regex.replaceAllIn(line, "\n")
   }

   def removeWhiteSpace(line: String): String = {
     val newLine = line.trim()
     if (newLine.isEmpty()) "" else s"$newLine\n"
   }
}
