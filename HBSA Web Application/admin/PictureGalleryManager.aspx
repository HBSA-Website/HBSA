<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="PictureGalleryManager.aspx.vb" Inherits="HBSA_Web_Application.PictureGalleryManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <h2 style="text-align: left">Picture Galleries Management.</h2>

    <table>
        <tr>
            <td style="vertical-align: top; width: 70%">
                <div style="padding: 2px;">
                    Use this page to maintain the pictures in the picture galleries.<br />
                    <br />
                    These pictures are identified by their names and the category they belong to.<br />
                    Picture files can be deleted, inserted and changed.<br />
                    They can also be downloaded.<br />
                    <br />
                    <table>
                        <tr style="vertical-align: top;">
                            <td>Select&nbsp;a&nbsp;Category<br />
                                &nbsp;&nbsp;&nbsp;(or&nbsp;choose&nbsp;to&nbsp;insert&nbsp;a&nbsp;new&nbsp;one):</td>
                            <td>
                                <asp:DropDownList ID="Category_DropDownList" runat="server" AutoPostBack="true" Style="min-width: 50px; max-width: 400px;" /></td>
                            <td>
                                <asp:RadioButtonList ID="EditCategory_RadioButton" runat="server" RepeatLayout="Flow" Visible="false" AutoPostBack="true" Font-Size="10pt">
                                    <asp:ListItem>Edit</asp:ListItem>
                                    <asp:ListItem>Delete</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr style="vertical-align: top;">
                            <td>Select a picture file<br />
                                &nbsp;&nbsp;&nbsp;(or choose to insert a new one):</td>
                            <td>
                                <asp:DropDownList ID="PictureNames_DropDownList" runat="server" AutoPostBack="true" Style="min-width: 50px; max-width: 400px;" /></td>
                            <td rowspan="2">
                                <asp:RadioButtonList ID="UpOrDownLoad" runat="server" RepeatLayout="Flow" Visible="false" AutoPostBack="true" Font-Size="10pt">
                                    <asp:ListItem>Upload</asp:ListItem>
                                    <asp:ListItem>Delete</asp:ListItem>
                                    <asp:ListItem>DownLoad</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr runat="server" id="snapshot">
                            <td colspan="3">
                                <asp:Image ID="snapshot_image" AlternateText="" runat="server" Height="200px" EnableViewState="False" BorderStyle="Solid" BorderColor="Black" BorderWidth="1px"></asp:Image>
                                <br />
                                <asp:Literal ID="Description_Literal" runat="server"></asp:Literal><br />
                            </td>
                        </tr>
                        <tr>
                        </tr>
                        <tr runat="server" id="DownloadButtonRow" visible="false">
                            <td></td>
                            <td>
                                <asp:Button ID="Download_Button" runat="server" /></td>
                        </tr>
                    </table>

                    <span style="font-size: larger; color: #000000">
                        <asp:Literal ID="Message_Literal" runat="server"></asp:Literal></span>

                    <asp:Panel ID="UpLoad_Panel" runat="server" Visible="false">

                        <script type="text/javascript">
                            function showFilename() {

                                var fileName = document.getElementById('<%=UploadFile.ClientID%>').value;
                            var startIx = fileName.lastIndexOf('\\');
                            var endIx = fileName.lastIndexOf('.');

                            fileName = fileName.substring(startIx + 1, endIx);

                            document.getElementById('<%=Description_TextBox.ClientID%>').value = fileName;
                            }
                        </script>

                        Click Browse and locate the file you wish to upload:<br />
                        NOTE if changing you must choose a picture to upload even if it is the same one.<br />
                        <asp:FileUpload ID="UploadFile" runat="server" Width="651px" onchange="showFilename();" />
                        <br />
                        Enter a full description/title for the picture:<br />
                        <asp:TextBox ID="Description_TextBox" runat="server" Width="923px" Height="47px" MaxLength="1023" TextMode="MultiLine"></asp:TextBox><br />
                        Then Click upload, to transfer the file to the Web Site and convert it:&nbsp;&nbsp;
                    <asp:Button ID="UpLoad_Button" runat="server" Text="Upload (and change)" Font-Size="10pt" />

                    </asp:Panel>

                </div>

            </td>
            <td style="vertical-align: top;">
                <div style="padding: 20px;">
                    <asp:Literal ID="Cat_Literal" runat="server">The pictures that can be managed for this category and with this facility are:</asp:Literal><br />
                    <br />
                    <asp:Literal ID="Files_Literal" runat="server"></asp:Literal>
                </div>
            </td>
        </tr>
    </table>

    <asp:Panel ID="Delete_Panel" runat="server" Visible="false">
        <div id="divDeletePicture" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display: block; vertical-align: top; text-align: left; position: fixed; background-color: #99CCFF; width: 300px; top: 374px; left: 100px;">
            <table style="width: 100%; height: 100%">
                <tr>
                    <td onmousedown="dragStart(event, 'divDeletePicture')"
                        onmouseover="this.style.cursor='pointer';"
                        style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                        <strong>
                            <asp:Literal ID="DeletePanel_Literal" runat="server" Text="Picture&nbsp;Details"></asp:Literal></strong></td>
                </tr>
            </table>
            <br />
            <div style="width: 100%; text-align: center; font-size: 10pt; color: #000099;">
                <asp:Literal ID="Delete_Literal" runat="server"></asp:Literal><br />
                <br />
            </div>

            <table style="width: 100%;">
                <tr>
                    <td style="text-align: center">
                        <asp:Button ID="ConfirmDelete_Button" runat="server" Text="Delete" />
                    </td>
                    <td style="text-align: center">
                        <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
                    </td>
                </tr>
            </table>


        </div>
    </asp:Panel>

    <asp:Panel ID="Category_Panel" runat="server" Visible="false">
        <div id="divEditCategory" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display: block; vertical-align: top; text-align: left; position: fixed; background-color: #99CCFF; width: 300px; top: 374px; left: 100px;">
            <table style="width: 100%; height: 100%">
                <tr>
                    <td onmousedown="dragStart(event, 'divEditCategory')"
                        onmouseover="this.style.cursor='pointer';"
                        style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                        <strong>
                            <asp:Literal ID="EditPanel_Literal" runat="server" Text="Picture&nbsp;Category"></asp:Literal></strong></td>
                </tr>
            </table>

            <div style="width: 100%; text-align: center; font-size: 10pt; color: #000099;">
                <asp:Literal ID="Category_Literal" runat="server"></asp:Literal><br />
                <br />
            </div>

            <table style="width: 100%;">
                <tr>
                    <th>Sequence</th>
                    <th>Category</th>
                </tr>
                <tr style="text-align:center">
                    <td>
                        <asp:TextBox ID="Sequence_TextBox" runat="server" Width="24px"></asp:TextBox></td>
                    <td>
                        <asp:TextBox ID="Category_TextBox" runat="server" Width="175px"></asp:TextBox></td>
                </tr>
            </table>

            <table style="width: 100%;">
                <tr>
                    <td style="text-align: center">
                        <asp:Button ID="Category_Button" runat="server" Text="Submit" />
                    </td>
                    <td style="text-align: center">
                        <asp:Button ID="CategoryCancel_Button" runat="server" Text="Cancel" />
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
