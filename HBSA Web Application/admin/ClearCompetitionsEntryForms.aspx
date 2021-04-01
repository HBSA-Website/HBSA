<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="ClearCompetitionsEntryForms.aspx.vb" Inherits="HBSA_Web_Application.ClearCompetitionsEntryForms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table style="width:auto; margin-left:auto; margin-right:auto;">
        <tr>
            <td style="text-align:center">
                <asp:Literal ID="ClearCompsEntryForms_Literal" runat="server"></asp:Literal><br /><br />
                <asp:Button ID="ClearCompsEntryForms_Button"  runat="server" Text="Click here to clear down ALL Competitions Entry Forms, ready to start a new competitions season." BorderStyle="None" Font-Bold="True" Font-Size="12pt" Font-Underline="True" ForeColor="#0066CC" /><br /><br />
                <span style="font-size: 11pt;">Note, that this will also archive the existing entry forms and payments.  Whilst this data is not lost it will require a technician to work on the database to retrieve it.</span>

            </td>
        </tr>
    </table>
</asp:Content>
