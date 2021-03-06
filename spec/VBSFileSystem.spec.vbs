
'Test the VBSFileSystem class

With CreateObject("includer")
    Execute(.read("VBSFileSystem"))
    Execute(.read("VBSNatives"))
    Execute(.read("TestingFramework"))
End With

Dim fs : Set fs = New VBSFileSystem
Dim n : Set n = New VBSNatives
Dim sh : Set sh = n.sh 
Dim fso : Set fso = n.fso

With New TestingFramework

    .describe "VBSFileSystem class"


        .it "should get a parent folder"

            Dim testFolder : testFolder = "C:\fake\path"

            .AssertEqual fso.GetParentFolderName(testFolder), fs.Parent(testFolder)

        .it "should resolve a relative path that starts with ../"

            fs.SetReferencePath "C:\Windows"
                    
            .AssertEqual fs.resolve("../System32"), "C:\System32"

        .it "should resolve a relative path that consists of just a folder name"

            .AssertEqual fs.resolve("System32"), "C:\Windows\System32"

        .it "should make a folder"

            Dim folder : folder = sh.ExpandEnvironmentStrings("%temp%\" & fso.GetTempName)
            Dim errMsg : errMsg = "Folder " & folder & " was not expected to exist."
            If fso.FolderExists(folder) Then Err.Raise 1, WScript.ScriptName, errMsg

            fs.MakeFolder(folder)

            .AssertEqual fso.FolderExists(folder), True

            fso.DeleteFolder(folder)

End With
