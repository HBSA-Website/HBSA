<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="editHomePage.aspx.vb" Inherits="HBSA_Web_Application.EditHomePage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../Scripts/JScript.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>Manage Home Page Articles</h2>
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ScriptManager>

    <asp:Button ID="New_Button" runat="server" Text="Create new Article" />
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="Delete_All_Button" runat="server" Text="Delete ALL Articles"  />
    <br />
    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>
    <br />
    <asp:GridView ID="HomePageArticles_GridView" runat="server" BackColor="White"  Font-Names="Calibri" Font-Size="10pt"
                  BorderColor="#4A3C8C" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" GridLines="Horizontal"
                  EmptyDataText="No articles in the database.">
        <AlternatingRowStyle BackColor="#F7F7F7" />
        <Columns>
            <asp:CommandField SelectText="Edit" ShowSelectButton="True" />
            <asp:CommandField ShowDeleteButton="True" />
        </Columns>
        <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
        <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
        <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
    </asp:GridView>

    <asp:Panel ID="EditPanel" runat="server" Visible="false" >
        <div id="EditDiv" style="border: 2px solid DarkBlue; position:fixed; width:90%; height:80%; top: 10%; left: 5%; 
                            background-color: white; color:#444444; text-align: left;">

            <input id="ID_Hidden" type="hidden" runat="server" />
            
            <strong>Title: </strong><asp:TextBox ID="Title_TextBox" width="478px" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Date_Literal" runat="server"></asp:Literal>
                <br/>
            <b>Article:</b>
                <br />
            <CKEditor:CKEditorControl ID="contentEditorTextBox" BasePath="/ckeditor/" runat="server" Toolbar="Basic"
                            ToolbarBasic="|Font|FontSize|Bold|Italic|Underline|Strike|-|Format|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|
                              |Link|Unlink|-|TextColor|-|Undo|Redo|Cut|Copy|Paste|PasteText|PasteFromWord|
                              |Find|Replace|SelectAll|-|Image|Table|HorizontalRule|SpecialChar|" Height="400px" Width="95%"></CKEditor:CKEditorControl>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Save_Button" runat="server" Text="Save" CssClass="smallButton" Width="79px"  />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Cancel_Button" runat="server" CssClass="smallButton" CausesValidation="false" Text="Cancel" Width="79px" />
                <br /><span style="color:red;"><asp:Literal ID="EditError_Literal" runat="server"></asp:Literal></span>
            <br />
        </div>
    </asp:Panel>

          <asp:Panel ID="ConfirmDelete_Panel" runat="server" Visible="False">
            <div id="divConfirm" 
                style="border: 1px solid DarkBlue; visibility:visible; position:fixed; top: 20%; left: 10%; 
                       background-color: white; text-align: center; color:#444444; font-size:small; width:600px;">
                <table style="width:100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divConfirm')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="text-align: left; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url(Images/menuBarBG.gif);">
                            <strong>Remove&nbsp;HomePage&nbsp;Article</strong></td>
                    </tr>
                </table>
                <br />
                <asp:Literal ID="Delete_Literal" 
                    runat="server" Text=""></asp:Literal>
                <br />
                <br /><br />
                <asp:Button ID="Delete_Button" runat="server" Font-Size="Small" Text="Delete" 
                    Width="60px" />
                &nbsp; &nbsp; &nbsp;
                <asp:Button ID="CancelDelete_Button" runat="server" Font-Size="Small" 
                    Text="Cancel" Width="60px" />
                <br />
                <br />
            </div>
        </asp:Panel>
  
</asp:Content>
