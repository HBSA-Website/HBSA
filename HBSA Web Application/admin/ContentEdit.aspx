<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="ContentEdit.aspx.vb" Inherits="HBSA_Web_Application.ContentEdit" %>

<%-- <%@Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>--%>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<%--    <script src="ckeditor/ckeditor.js"></script>
<script>
    CKEDITOR.env.isCompatible = true;
</script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <%@Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>--%>
    <input id="ContentName_HiddenField" type="hidden" runat="server"/>
    <%--<asp:ScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ScriptManager>--%>Content Name: <asp:TextBox ID="ContentName_TextBox" runat="server" Enabled="false" Width="338px"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date: <asp:Literal ID="Date_Literal" runat="server"/><br />
            Content:<asp:Literal ID="Message_Literal" runat="server"></asp:Literal><br />
    <asp:Button ID="Submit_Button1" runat="server" Text="Save" CausesValidation="false" CssClass="smallButton" Width="90px" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Cancel_Button1" runat="server" CssClass="smallButton" CausesValidation="false" Text="Cancel" Width="90px" />

    <CKEditor:CKEditorControl ID="contentEditorBox" BasePath="/ckeditor/" runat="server" Toolbar="Basic"
        ToolbarBasic="|Font|FontSize|Bold|Italic|Underline|Strike|-|Format|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|
                              |Link|Unlink|-|TextColor|-|Undo|Redo|Cut|Copy|Paste|PasteText|PasteFromWord|
                              |Find|Replace|SelectAll|-|Image|Table|HorizontalRule|SpecialChar|"
        Height="480px" Width="95%"></CKEditor:CKEditorControl>

            <asp:Button ID="Submit_Button" runat="server" Text="Save" CausesValidation="false" CssClass="smallButton" Width="90px"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Cancel_Button" runat="server" CssClass="smallButton" CausesValidation="false" Text="Cancel" Width="90px" />

<%--            <asp:TextBox ID="contentEditorTextBox" runat="server" Height="600px" width="100%"></asp:TextBox>
                 <AjaxToolkit:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="contentEditorTextBox" DisplayPreviewTab="True" DisplaySourceTab="True" EnableSanitization="False"></AjaxToolkit:HtmlEditorExtender>--%>


</asp:Content>
