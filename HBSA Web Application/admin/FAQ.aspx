<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="FAQ.aspx.vb" Inherits="HBSA_Web_Application.FAQ" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ScriptManager>

    <h3>FAQ Maintenance</h3>
    <asp:Button ID="Save_Button" runat="server" Text="Save" Width="122px" />
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Click save when finished or select another function.<br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="FAQ_Literal" runat="server"></asp:Literal><br />
       
    <CKEditor:CKEditorControl ID="contentEditorTextBox" BasePath="/ckeditor/" runat="server" Toolbar="Basic"
        ToolbarBasic="|Font|FontSize|Bold|Italic|Underline|Strike|-|Format|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|
                              |Link|Unlink|-|TextColor|-|Undo|Redo|Cut|Copy|Paste|PasteText|PasteFromWord|
                              |Find|Replace|SelectAll|-|Image|Table|HorizontalRule|SpecialChar|"
        Height="400px" Width="95%"></CKEditor:CKEditorControl>
    <asp:Button ID="Save_Button2" runat="server" Text="Save" Width="122px" />

</asp:Content>
