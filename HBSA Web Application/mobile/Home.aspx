<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="mobileMaster.Master" CodeBehind="Home.aspx.vb" Inherits="HBSA_Web_Application.MobileHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" >
        function swapDiv(divID, imgID) {

            if (document.getElementById(imgID).src.search("PointUpSmall") != -1) {
                document.getElementById(divID).style.display = "none";
                document.getElementById(imgID).src = "../Images/PointDownSmall.bmp";
            }
            else {
                document.getElementById(divID).style.display = "block";
                document.getElementById(imgID).src = "../Images/PointUpSmall.bmp";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="margin: 4px">
         <div style="margin-left:auto;margin-right:auto; width:100%; font-weight:bold; text-align:center; font-size:14px;">Important website update.</div>
        <div style="padding: 4px; margin: 4px; border: thin solid #008000; font-size:12px;">
            1. We have been forced to revert to our own contingency backup due to a problem with our website host.
            <br />
            <br />
            2. UNFORTUNATELY, SOME RECENT RESULTS HAVE BEEN LOST (entered after 5pm 28th Oct).

            <br />
            <br />
            3. <a href="https://huddersfieldsnooker.com/MissingResults.aspx">PLEASE COULD YOU CLICK/TOUCH HERE</a>
<strong>AND RE-INPUT THE MISSING RESULTS FOR YOUR TEAM.</strong> Please note that if the card has been lost or destroyed, the person registered to enter results will have been sent an email with a copy of the full results card.
            <br />
            <br />
            4. The results from the Open League games on 3rd Nov can now be input as normal.
            <br />
            <br />
            5. Competition entry forms submitted after 5pm Oct 28th have also been lost. The Competition Sec will issue a separate update on this in the next day or two. <strong>IN THE MEANTIME, IF YOU HAVE ARRANGED ANY GAMES PLEASE DO NOT PLAY THEM YET, AS THE DRAWS MAY HAVE TO BE REDONE. </strong>
            <br />
            <br />
            Please accept our sincerest apologies and thanks for your support.

            <br />

        </div>
   
        <div id="HandicapChangesDiv" runat="server" class="HandicapChanges">
            <asp:Literal ID="HandicapChanges_Literal" runat="server" >Handicap changes made during the last week. Emails have been sent to all relevant persons that can be found in the system.</asp:Literal>
                        <asp:GridView ID="HandicapChanges_GridView" runat="server" HorizontalAlign="Center" CellPadding="4" >
                            <HeaderStyle CssClass="gridViewHeaderHcap" />
                            <RowStyle CssClass="gridViewRowHcap"/>
                            <AlternatingRowStyle CssClass="gridViewAltHcap" />
                        </asp:GridView>
        </div>
        <div id="NewRegistrationsDiv" runat="server" class="HandicapChanges" onmouseover="hideMenuDiv();">
            <asp:Literal ID="NewRegistrations_Literal" runat="server">New registrations made during the last week.</asp:Literal>
                        <asp:GridView ID="NewRegistrations_GridView" runat="server" HorizontalAlign="Center" CellPadding="4" >
                            <HeaderStyle CssClass="gridViewHeaderHcap"/>
                            <RowStyle CssClass="gridViewRowHcap" />
                            <AlternatingRowStyle CssClass="gridViewAltHcap" />
                        </asp:GridView>
        </div>

        <div style="width: 100%; text-align: center; font-style: italic; font-size:16px;color:black ">Click or touch a title bar to see the article.</div>
        <asp:Literal ID="HomePage_Literal" runat="server"></asp:Literal>

</div>
    
</asp:Content>
