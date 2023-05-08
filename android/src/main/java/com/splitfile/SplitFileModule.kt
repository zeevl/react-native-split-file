package com.splitfile

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableArray
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream




class SplitFileModule internal constructor(context: ReactApplicationContext) :
  SplitFileSpec(context) {

  override fun getName(): String {
    return NAME
  }


  @ReactMethod
  override fun splitFileIntoChunks(path: String, chunkSize: Int, promise: Promise) {
    // Check if the file exists
    val file = File(path)
    if (!file.exists()) {
        val errorMessage = "File not found: $path"
        val error = Exception(errorMessage)
        promise.reject("file_not_found", errorMessage, error)
        return
    }

    // Open the input file
    val inputFileStream = FileInputStream(file)
    val inputChannel = inputFileStream.channel

    // Get the file size and calculate the number of chunks
    val fileSize = inputChannel.size()
    val numberOfChunks = kotlin.math.ceil(fileSize.toDouble() / chunkSize.toDouble()).toInt()

    // Initialize the output filenames array
    val writableArray: WritableArray = Arguments.createArray()
    val outputFilenames = mutableListOf<String>()

    // Read and write chunks of data to output files
    for (i in 0 until numberOfChunks) {
        try {
            // Read a chunk of data from the input file
            val chunkData = java.nio.ByteBuffer.allocate(chunkSize)
            inputChannel.read(chunkData)
            chunkData.flip()

            val outputFilename = "$path.$i"
            writableArray.pushString(outputFilename)

            // Write the chunk data to the output file
            val outputFile = File(outputFilename)
            val outputFileStream = FileOutputStream(outputFile)
            val outputChannel = outputFileStream.channel
            outputChannel.write(chunkData)
            outputChannel.close()
            outputFileStream.close()
        } catch (e: Exception) {
            val errorMessage = "Failed to read/write chunk $i of file: $path"
            promise.reject("chunk_error", errorMessage, e)
            return
        }
    }

    // Close the input file
    inputChannel.close()
    inputFileStream.close()

    // Return the array of output filenames


    promise.resolve(writableArray)
    // promise.resolve("it worked")
  }


  companion object {
    const val NAME = "SplitFile"
  }
}

