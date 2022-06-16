macro "1RO1MiguelGCaMP_ShockResponses_times2" {

filename=getTitle;
filesize=nSlices;
roiManager("reset");
run("Select None");
print("\\Clear");


//Get DFF GcaMP6 signal 

//Prepare GCaMP6 
selectWindow(filename);
run("Fire");
run("In [+]");
run("In [+]");
run("Image Stabilizer", "transformation=Translation maximum_pyramid_levels=1 template_update_coefficient=0.90 maximum_iterations=200 error_tolerance=0.0000001");
run("Z Project...", "projection=[Max Intensity]");
run("Window/Level...");
waitForUser("check the Max projection");
run("Close");



//Select ROIs using
waitForUser("select signal ROI press t and then background ROI press t");

numSlices = nSlices;
title = getTitle();

// Select GCaMP signal as the second-to-last ROI in ROI manager
roiManager("select", (roiManager("count") - 2));
run("Plot Z-axis Profile");
f = newArray(numSlices);
for (i=0; i<numSlices; i++) {
	f[i] = getResult("Mean", i);
}
selectWindow("Results");
run("Close","Don't Save");
run("Close");

selectWindow(title);

// Select the background signal as the last ROI in ROI manager
roiManager("select", (roiManager("count") - 1));
run("Plot Z-axis Profile");
bkgnd = newArray(numSlices);
for (i=0; i<numSlices; i++) {
	bkgnd[i] = getResult("Mean", i);
}
selectWindow("Results");
run("Close","Don't Save");
run("Close");

// Subtract background to the GCaMP signal
for (i=0; i<numSlices; i++) {
	f[i] = f[i] - bkgnd[i];
}


// Print
for (i=0; i<nSlices; i++) {
print(f[i]);
};
selectWindow("Log");
waitForUser("Done");
run("Close All");
}
