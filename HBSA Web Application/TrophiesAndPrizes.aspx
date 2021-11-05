<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="TrophiesAndPrizes.aspx.vb" Inherits="HBSA_Web_Application.TrophiesAndPrizes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div id="iframeContainer"></div>

<script>
    var URL = 'https://docs.google.com/viewer?url=https://huddersfieldsnooker.com/Documents/Trophies and Prizes.pdf&embedded=true';
    var count = 0;
    var iframe = ` <iframe id = 'myIframe' src = "${URL}" style = 'width:100%; height:2500px;'  frameborder = '0'></iframe>`;
    $(`#iframeContainer`).html(iframe);
    $('#myIframe').on('load', function () {
        count++;
        if (count > 0) {
            clearInterval(ref)
        }
    });
    var ref = setInterval(() => {
        $(`#iframeContainer`).html(iframe);
        $('#myIframe').on('load', function () {
            count++;
            if (count > 0) {
                clearInterval(ref)
            }
        });
    }, 2500)
</script>

</asp:Content>