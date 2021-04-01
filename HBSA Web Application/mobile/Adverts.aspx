<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.master" CodeBehind="Adverts.aspx.vb" Inherits="HBSA_Web_Application.Adverts2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2 style="text-align: left">Adverts.</h2>

                    Use this page to view any of the advertisements.<br />
                    <br />
                    These adverts are identified by the advertisers.<br />
                    If the advertsier supplied his/her web address, clicking the advert will take you to that web page.
                    <br />
                    <br />
                    Select an advert: <asp:DropDownList ID="Adverts_DropDownList" runat="server" AutoPostBack="true" />
                    <br /><asp:Literal ID="WebURL_Literal" runat="server"></asp:Literal>
                    <br /><a id="snapshot_link" runat="server" href="~/Advert.ashx" target="_blank">
                            <img id="snapshot_img" src="data:image/JPEG;base64," runat="server" style="border: 1px solid black;width:100%" />
                                </a>

</asp:Content>
