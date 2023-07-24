


#@ DatasetIOService io
#@ CommandService command
#@ ConvertService convert
import os
from ij import ImagePlus
from ij.gui import GenericDialog
import ij. IJ as IJ
import java.io.File as File
from de.csbdresden.stardist import StarDist2D 
from glob import glob
from net.imglib2.img.display.imagej import ImageJFunctions as IJF
 
def run():
  srcDir = IJ.getDirectory("Input_directory")
  if not srcDir:
	return
  dstDir = IJ.getDirectory("Output_directory")
  if not dstDir:
	return
  gd = GenericDialog("Process Folder")
  gd.addStringField("File_extension", ".tif")
  gd.addStringField("File_name_contains", "")
  gd.addCheckbox("Keep directory structure when saving", True)
  gd.showDialog()
  if gd.wasCanceled():
	return
  ext = gd.getNextString()
  containString = gd.getNextString()
  keepDirectories = gd.getNextBoolean()
    
  for root, directories, filenames in os.walk(srcDir):
	for filename in filenames:
	  # Check for file extension
	  if not filename.endswith(ext):
		continue
	  # Check for file name pattern
	  if containString not in filename:
		continue
	
	  process(srcDir, dstDir, root, filename, keepDirectories)

def process(srcDir, dstDir, currentDir, fileName, keepDirectories):
  print "Processing:"
  
  # Opening the image
  print "Open image file", fileName
  imp = IJ.openImage(os.path.join(currentDir, fileName))
  # Preprocessing 
  IJ.run(imp,"Enhance Contrast...", "saturated=0.3 normalize process_all")
  IJ.run(imp,"Subtract Background...", "rolling=50 stack")
  # Run the Stardist
  res = command.run(StarDist2D, False,
			 "input", imp, "modelChoice", "Versatile (fluorescent nuclei)",
			 "modelFile","/path/to/TF_SavedModel.zip",
			 "normalizeInput",True, "percentileBottom",1, "percentileTop",99.8,
			 "probThresh",0.5, "nmsThresh", 0.0, "outputType","Label Image",
			 "nTiles",1, "excludeBoundary",2, "verbose",1, "showCsbdeepProgress",1, "showProbAndDist",0).get();	
  label = res.getOutput("label")

  # Post processing
  
  myImagePlus = IJF.wrap( label, "myArrayImgTitle") #Change data type of label to Imageplus
  IJ.setThreshold(myImagePlus,1, 65535);
  IJ.run(myImagePlus, "Convert to Mask", "")
  IJ.run(myImagePlus, "Erode","")
  
  # Saving the image
  saveDir = currentDir.replace(srcDir, dstDir) if keepDirectories else dstDir
  if not os.path.exists(saveDir):
	os.makedirs(saveDir)
  print "Saving to", saveDir
  IJ.save(myImagePlus,os.path.join(saveDir, "Mask_" + fileName))
  #io.save(label, os.path.join(saveDir, "Label_" + fileName))
  imp.close()

run()
print "Job is done!"
