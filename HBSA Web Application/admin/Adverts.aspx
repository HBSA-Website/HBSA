<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Adverts.aspx.vb" 
        Inherits="HBSA_Web_Application.Adverts" ClientIDMode="Static" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
    function loadDiv(divID) {
        if ((divID != 'loading') && (divID != 'updating')) {
            var perCent
            if (divID == 'cfgHelp1') {
                perCent = 8 / 100;
            }
            else {
                perCent = 15 / 100;
            }
            // calc left as 15 % of page width
            var divLeft = document.documentElement.clientWidth * perCent;
            // calc top as 15 % of page height
            var divTop = document.documentElement.clientHeight * perCent;
            document.getElementById(divID).style.top = divTop;
            document.getElementById(divID).style.left = divLeft;
        }
        document.getElementById(divID).style.display = "block";
        if (divID == 'loading') {
            //ensure animated loading gif runs after post back
            setTimeout('document.images["imgLoading"].src="Images/loading.gif"', 200);
        }
        else if (divID == 'updating') {
            setTimeout('document.images["imgupdating"].src="Images/loading.gif"', 200);
        }
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2 style="text-align: left">Adverts Management.</h2>

    <script type="text/javascript">
        function showFilename() {

            var ddList = document.getElementById('<%=Adverts_DropDownList.ClientID%>');
            var ix = ddList.selectedIndex;

            if (ix == "1") {
                var fileName = document.getElementById('<%=UploadFile.ClientID%>').value;
                var startIx = fileName.lastIndexOf('\\');
                var endIx   = fileName.lastIndexOf('.');
                fileName = fileName.substring(startIx + 1, endIx);
                document.getElementById('<%=Advertiser_TextBox.ClientID%>').value = fileName;
            }
        }
    </script>

    <table>
        <tr>
            <td style="width: 70%; vertical-align: top">
                <div style="padding: 20px;">
                    Use this page to maintain the advertisements.<br /><br />
                    These adverts are identified by their names.<br />
                    Adverts can be deleted, inserted and changed. Note that adverts are held as pictures(images).  Any text must be included in the image.<br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If a Web URL (web address) is added, clicking the advert will take the user to that web page.
                    They can also be downloaded.<br /><br /> 
                    <table>
                        <tr style="vertical-align:top">
                            <td style="text-align:right" >Select an advert:<br /><b> OR </b>
                                <asp:Button ID="Add_Button" runat="server" Text="Add a new one" /></td>
                            <td><asp:DropDownList ID="Adverts_DropDownList" runat="server" AutoPostBack="true" max-width="600px"/></td>
                            <td rowspan="2" id="actionButtons" runat="server" visible="false"> 
                                <asp:Button ID="Change_Button" runat="server" Text="Change" Width="124px" /><br />
                                <asp:Button ID="Delete_Button" runat="server" Text="Delete" Width="124px" /><br />
                                <asp:Button ID="Download_Button" runat="server" Text="Download" Width="124px" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                            </td>
                        </tr>
                    </table>
                
                    <asp:Literal ID="Message_Literal" runat="server"></asp:Literal>

                <asp:Panel ID="UpLoad_Panel" runat="server" Visible="false">
                    
                    Click Browse and locate the file you wish to upload (if this is left blank only the advertiser and/or the WebURL will be changed):<br />
                    <asp:FileUpload ID="UploadFile" runat="server" Width="651px" onchange="showFilename();"/>
                    <br />
                    Enter the advertiser<br /><asp:TextBox ID="Advertiser_TextBox" runat="server" MaxLength="255" Width="923px"></asp:TextBox>
                    <br />
                    Enter the internet address for this advert<br /><asp:TextBox ID="WebURL_TextBox" runat="server" MaxLength="1023" Width="923px"></asp:TextBox>
                    <br />
                    Then Click upload/change, to transfer the file to the Web Site and convert it, and/or amend the advertiser, and/or amend the Web URL:&nbsp;&nbsp;
                    <asp:Button ID="UpLoad_Button" runat="server" Text="Upload/Change" Font-Size="10pt" />
    
                </asp:Panel>

                                <asp:panel id="Download_Panel" runat="server" Visible="false" EnableViewState="false">
                                    <asp:Literal ID="Advertiser_Literal" runat="server"></asp:Literal><br />
                                    <%--<asp:image ID="snapshot_image" AlternateText="" runat="server" EnableViewState="False" width="260" BorderStyle="Solid" BorderColor="Black" BorderWidth="1px"></asp:image>--%>
                                    <img id="snapshot_img" src="data:image/JPEG;base64," runat="server" style="border: 1px solid black; width:260px;" />
                                </asp:panel>
            </div>

            </td>
            <td style="vertical-align:top">
                <div style="padding: 4px;">
                 The adverts that can be managed with this facility are:<br /><br />
                    <asp:Literal ID="Files_Literal" runat="server"></asp:Literal>
                </div>
            </td>
        </tr>
    </table>

         <asp:Panel ID="Delete_Panel" runat="server" Visible="false">
            <div id="divDeletePicture" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:300px; top: 374px; left:100px;
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divDeletePicture')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="DeletePanel_Literal" runat="server" Text="Advertisement"></asp:Literal></strong></td>
                    </tr>
                </table>
                <br />
                <div style="width:100%; text-align:center; font-size: 10pt; color: #000099;">
                    <asp:Literal ID="Delete_Literal" runat="server"></asp:Literal><br/><br/>
                </div>

                <table style="width:auto;margin-left:auto;margin-right:auto;">
                    <tr>
                        <td style="text-align:center">
                            <asp:Button ID="ConfirmDelete_Button" runat="server" Text="Delete" />
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align:center">
                            <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
                        </td>
                    </tr>
                </table>

  
            </div>
        </asp:Panel>

        
    <div id="loading" 
        style="position: fixed; top: 190px; left: 700px; display: none">
        <img id="imgLoading" alt="loading" src="images/loading.gif" width="36" />
    </div>

</asp:Content>