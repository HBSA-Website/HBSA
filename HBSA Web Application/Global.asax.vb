Imports HBSAcodeLibrary
Imports DeviceDetectorNET
Imports System.IO
Imports System.Web.HttpContext
Public Class Global_asax
    Inherits HttpApplication
    Sub Application_Start(sender As Object, e As EventArgs)
        ' Fires when the application is started
        'HBSAcodeLibrary.ActivityLog.LogActivity("Web Application Start", 0, "Global")
    End Sub
    Sub Application_End(sender As Object, e As EventArgs)
        ' Fires when the application is stopped
        'HBSAcodeLibrary.ActivityLog.LogActivity("Web Application End", 0, "Global")
    End Sub

    Sub Session_Start(sender As Object, e As EventArgs)

        'encode the connection string
        Dim filePath As String = Current.Server.MapPath("~/App_Data/HBSA.dat")
        Dim connStr As String = File.ReadAllText(filePath)
        If connStr.StartsWith("[connStr]") Then
            File.WriteAllText(filePath, HBSAencoder.Encode(connStr.Substring(9).Trim()))
        End If

        ''Ensure unique SessionID
        'If SessionInfo.SessionIDexists(Session.SessionID) Then
        '    Dim manager As SessionIDManager = New SessionIDManager()
        '    Dim newID As String = manager.CreateSessionID(Context)
        '    Dim redirected As Boolean = False
        '    Dim isAdded As Boolean = False
        '    manager.SaveSessionID(Context, newID, redirected, isAdded)
        '    Exit Sub
        'End If

        '<description>The Universal Device Detection library For .NET that parses User Agents And 
        '   detects Devices(desktop, tablet, mobile, tv, cars, Console, etc.), clients(browsers, feed readers, Media players, PIMs, ...), 
        '   operating systems, brands And models.This Is a port Of the popular PHP device-detector library To C#. 
        '   For the most part you can just follow the documentation For device-detector With no issue.</description>
        ' <summary>The Universal Device Detection library will parse any User Agent And detect the browser, operating system, 
        '   device used(desktop, tablet, mobile, tv, cars, Console, etc.), brand And model.</summary>
        ' <copyright>Copyright © www.totpe.ro</copyright>
        ' <tags>parse detection-library user-agent bot-detection mobile-detection desktop tablet mobile tv cars console</tags>
        ' <dependencies>
        '   <group targetFramework = ".NETFramework4.5" >
        '     <dependency id="YamlDotNet.Signed" version="5.3.0"/>
        '           </group>
        ' </dependencies>

        Try
            ' set up DeviceDetector and set session variable if mobile is detected
            ' OPTIONAL Set version truncation to none, so full versions will be returned
            ' By default only minor versions will be returned (e.g. X.Y)
            ' for other options see VERSION_TRUNCATION_* constants in DeviceParserAbstract class
            ' add using DeviceDetectorNET.Parser;

            DeviceDetectorSettings.RegexesDirectory = Server.MapPath("~/bin/")
            DeviceDetector.SetVersionTruncation(DeviceDetectorNET.Parser.Client.Browser.Engine.VersionParser.VERSION_TRUNCATION_NONE)

            Dim dd As DeviceDetector
            dd = New DeviceDetector(Request.UserAgent)


            ' OPTIONAL If called Then, GetBot() will only Return True If a bot was detected  (speeds up detection a bit)
            dd.DiscardBotInformation()

            'Assemble the information
            dd.Parse()

            If Not dd.IsBot Then
                Dim clientInfo = dd.GetClient.ToString
                Dim osInfo = dd.GetOs.ToString
                Dim device = dd.GetDeviceName 'smartphone, tablet, desktop
                Dim brand = dd.GetBrandName
                Dim model = dd.GetModel

                Session("mobile") = (device = "smartphone") Or (device = "phablet")

            End If

        Catch ex As Exception

            HBSAcodeLibrary.ActivityLog.LogActivity("DeviceDetector(Request.UserAgent): " & ex.Message.Replace("'", "''"), 0, "Global")
            '            SessionInfo.open(Session.SessionID, "DeviceDetector(Request.UserAgent): ", ex.Message.Replace("'", "''"), "", "", "")

        End Try


        Using GlobalPage As New HBSAcodeLibrary.PageCounter("Global")

            Session("HitCount") = GlobalPage.HitCounter + 1

            If GlobalPage.PageName = "Global" Then
                GlobalPage.Merge(Session("HitCount"))
            Else
                Session("HitCount") = "<font color=red>Cannot find the visitor count.  Please inform us via the contact page.</font>"
            End If

        End Using

        'ensure Over70 flag is kept reset for open league (Over 70 handicap rule has been rescinded)
        SharedRoutines.KeepOver70FlagOff()

        'get randomised list of advertisers
        Dim RandomisedAdverts As HBSAcodeLibrary.Advert.RandomAdverts = HBSAcodeLibrary.Advert.RandomiseAdverts
        Session("NoAdverts") = RandomisedAdverts.noAdverts
        Session("Advertisers") = RandomisedAdverts.advertisers
        Session("LastAdvert") = RandomisedAdverts.lastAdvert
        Session("advertCounter") = RandomisedAdverts.advertCounter

    End Sub

    'Sub Session_End()

    '    SessionInfo.close(Session.SessionID)

    'End Sub

    '''' <summary>
    '''' Generates a random Integer with any (inclusive) minimum or (inclusive) maximum values, with full range of Int32 values.
    '''' </summary>
    '''' <param name="inMin">Inclusive Minimum value. Lowest possible return value.</param>
    '''' <param name="inMax">Inclusive Maximum value. Highest possible return value.</param>
    '''' <returns></returns>
    '''' <remarks></remarks>
    'Private Function GenRandomInt(inMin As Int32, inMax As Int32) As Int32
    '    Static staticRandomGenerator As New System.Random
    '    If inMin > inMax Then Dim t = inMin : inMin = inMax : inMax = t
    '    If inMax < Int32.MaxValue Then Return staticRandomGenerator.Next(inMin, inMax + 1)
    '    ' now max = Int32.MaxValue, so we need to work around Microsoft's quirk of an exclusive max parameter.
    '    If inMin > Int32.MinValue Then Return staticRandomGenerator.Next(inMin - 1, inMax) + 1 ' okay, this was the easy one.
    '    ' now min and max give full range of integer, but Random.Next() does not give us an option for the full range of integer.
    '    ' so we need to use Random.NextBytes() to give us 4 random bytes, then convert that to our random int.
    '    Dim bytes(3) As Byte ' 4 bytes, 0 to 3
    '    staticRandomGenerator.NextBytes(bytes) ' 4 random bytes
    '    Return BitConverter.ToInt32(bytes, 0) ' return bytes converted to a random Int32
    'End Function



End Class