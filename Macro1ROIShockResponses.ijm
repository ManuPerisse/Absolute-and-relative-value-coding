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

{
numSlices = nSlices;
title = getTitle();

//nAvg = getNumber("Average F0 over first X frames: (enter X)", 50);
//Select first F01
Dialog.create("Frames over which to average F0_1");
Dialog.addNumber("To1", 188);
Dialog.show();
to1 = Dialog.getNumber();
from1 = to1 - 13;
if (to1 <= from1) exit("Error: To value must be greater than from value");
nAvg1 = to1 - from1;
//Select second F02
Dialog.create("Frames over which to average F0_1");
Dialog.addNumber("To2", 849);
Dialog.show();
to2 = Dialog.getNumber();
from2 = to2 - 13;
if (to2 <= from2) exit("Error: To value must be greater than from value");
nAvg2 = to2 - from2;

print("\\Clear");

selectWindow(title);

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

// Calculate average over frames specified by from-to 1
sum = 0;
for (i=from1; i<to1; i++) {
	sum = sum + f[i];
	f01 = sum / nAvg1;
}
// Calculate average over frames specified by from-to 2
sum = 0;
for (i=from2; i<to2; i++) {
	sum = sum + f[i];
	f02 = sum / nAvg2;
}



// Calculate DF/F 1
dff1 = newArray(numSlices);
for (i=0; i<nSlices; i++) {
	dff1[i] = (f[i] - f01) / f01;
}
// Calculate DF/F 2
dff2 = newArray(numSlices);
for (i=0; i<nSlices; i++) {
	dff2[i] = (f[i] - f02) / f02;
}

// Print
for (i=0; i<nSlices; i++) {
print(dff1[i]+"	"+dff2[i]);
String.append(dff1[i]+"	"+dff2[i]+"\n");
};
selectWindow("Log");
waitForUser("Done");
run("Close All");
}
