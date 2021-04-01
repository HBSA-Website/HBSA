<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="DocumentManager.aspx.vb" Inherits="HBSA_Web_Application.DocumentManager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {width: 180px;text-align:right;        }
        .auto-style2 {width: 150px;text-align:left;        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2 style="text-align: left">Documents Manager.</h2>

    <table>
        <tr>
            <td style="vertical-align:top;width:70%">
                <div style="padding: 20px;">
                    Various pages in the web site offer the ability to download certain documents.&nbsp;&nbsp;
                    Use this page to maintain those files. 
                    <br />
                    Each document has a very specific filename and extension.&nbsp; It is important that these files exist and have exactly the correct filename.<br />
                    <br />
                    First select a document. The document may then be downloaded.<br />
                    Note: to change a document you may download the document and edit it, then upload it.&nbsp; Alternatively simply upload a new document.<br />
                    <br />
                    <br /> 
                    <table >
                        <tr>
                            <td class="auto-style1">Select a document:</td>
                            <td class="auto-style2"><asp:DropDownList ID="Documents_DropDownList" runat="server" AutoPostBack="true"/></td>
                            <td class="auto-style1"> or load a new document:</td>
                            <td class="auto-style2"> <asp:Button ID="NewDocument_Button" runat="server" Text="Load a new document" /></td>
                        </tr>
                    </table>

                <asp:Panel ID="UpLoad_Panel" runat="server" Visible="false">
                    <table id="DownloadTable" runat="server">
                        <tr id="downLoadRow" runat="server">
                            <td class="auto-style1">Click to download:</td>
                            <td class="auto-style2"><asp:Button ID="Download_Button" text="Download" runat="server" /></td>
                            <td class="auto-style1">Click to remove the document:</td>
                            <td class="auto-style2"><asp:Button ID="Delete_Button" Text="Remove this document" runat="server" /></td>
                        </tr>
                    </table>
                    <div id="removeDoc" runat="server" style="color:brown; font-size:larger;" visible="false">
                        Click Confirm to remove <asp:Literal ID="Remove_Literal" runat="server" /> from the website. &nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="Confirm_Button" runat="server" Text="Confirm" />&nbsp;&nbsp;&nbsp;&nbsp;or&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
                    </div>
                    <br />
                    <table>
                        <tr>
                            <td>Click Browse/Choose File to locate the document file to upload:</td>
                        </tr>
                        <tr>
                            <td><asp:FileUpload ID="FileUploadControl" runat="server" Width="594px" /></td>
                        </tr>
                        <tr>
                            <td style="vertical-align:top;">Then Click upload, to transfer the document to the Web Site:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                <asp:Button ID="UpLoad_Button" runat="server" Text="Upload" Font-Size="10pt" /></td>
                        </tr>
                    </table>

                </asp:Panel>

               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Status_Literal" runat="server"></asp:Literal>

            </div>

            </td>
        </tr>
    </table>

</asp:Content>
