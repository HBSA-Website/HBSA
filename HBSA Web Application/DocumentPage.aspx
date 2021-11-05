<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="DocumentPage.aspx.vb" Inherits="HBSA_Web_Application.DocumentPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="iframeContainer"></div>

<script>

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return typeof sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
            }
        }
        return false;
    };

    var fName = getUrlParameter('document')
    var URL = 'https://docs.google.com/viewer?url=https://huddersfieldsnooker.com/Documents/' + fName + '&embedded=true';
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
