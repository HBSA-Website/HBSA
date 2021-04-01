<%@ Page Title="HBSA Picture Gallery" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" ClientIDMode="Static"
    CodeBehind="PictureGallery.aspx.vb" Inherits="HBSA_Web_Application.PictureGallery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style type="text/css">
        .PictureBox {
            max-width: 100%;
            max-height: 400px;
            width: auto;
            height: auto;
            border-style: solid;
            border-width: 1px;
            border-color: black;
        }

        .PicturePanel {
            top: 250px;
            left: 25%;
            width: 50%;
            background-color: white;
            color: black;
            text-align:center;
            border-color:black;
            border-width:1px;
            border-style:solid;
            position:fixed;
        }

        .thumbNail {
            Height:80px;
            border-color:#ccffcc;
            border-width:4px;
            border-style:solid;
        }

    </style>

    <script type="text/javascript">
            function firstImage() {
                showPicture(0);
            }
            function previousImage() {
                var currentIx = parseInt(document.getElementById("PictureIndex_Hidden").value);
                if (currentIx > 0) {
                    showPicture(currentIx - 1);
                }
            }
            function nextImage() {
                var currentIx = parseInt(document.getElementById("PictureIndex_Hidden").value);
                var picturesCount = parseInt(document.getElementById("PicturesCount_Hidden").value);
                if (currentIx < picturesCount-1) {
                    showPicture(currentIx + 1);
                }
            }
            function lastImage() {
                var picturesCount = parseInt(document.getElementById("PicturesCount_Hidden").value);
                showPicture(picturesCount-1);
            }

            function showPicture (pictureIndex) {
                var thumbId = "Thumb" + pictureIndex;
                var thumb = document.getElementById(thumbId);
                var img = document.getElementById("Picture_Image");
                var picturesCount = parseInt(document.getElementById("PicturesCount_Hidden").value);

                document.getElementById("PictureIndex_Hidden").value = pictureIndex;
                img.src=thumb.src;
                img.alt = thumb.alt;
                var span = document.getElementById("ImageDescription_Label");
                span.textContent = thumb.alt;
                
                if (pictureIndex >= picturesCount-1) {
                    document.getElementById("nextButton").src = "Images/BlueCircle-Next-Disabled.png";
                    document.getElementById("lastButton").src = "Images/BlueCircle-Last-Disabled.png";
                }
                else {
                    document.getElementById("nextButton").src = "Images/BlueCircle-Next.png";
                    document.getElementById("lastButton").src = "Images/BlueCircle-Last.png";

                }
                if (pictureIndex < 1) {
                    document.getElementById("prevButton").src = "Images/BlueCircle-Previous-Disabled.png";
                    document.getElementById("firstButton").src = "Images/BlueCircle-First-Disabled.png";
                }
                else {
                    document.getElementById("prevButton").src = "Images/BlueCircle-Previous.png";
                    document.getElementById("firstButton").src = "Images/BlueCircle-First.png";
                }

                loadDiv('PicturePanel')
            }
        </script> 

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div style="font-family: Verdana; font-size: small; color: #004400; background-color: #ccffcc; width: 100%; text-align: center">
        <h3>Picture Gallery</h3>
        <table style="width:100%;">
            <tr>
                <td style="text-align: right; width: 50%">Choose a viewing room:</td>
                <td style="text-align: left; width: 50%">
                    <asp:DropDownList ID="Room_DropDownList" runat="server" AutoPostBack="true" onchange="hideDiv('PicturePanel');"  />
                </td>
            </tr>
        </table>
        <asp:Literal ID="Text_Literal" runat="server"></asp:Literal>
        <br />
        Click on a thumbnail to see full sized picture.<br />
        Move the mouse pointer and hover over a thumbnail to see the picture's title.<br />
        Right click on a thumbnail, then click &quot;Save Image as...&quot; or &quot;Save
        Picture as...&quot; to download a copy.<br />
        <br />

        <asp:Panel ID="Thumbnails_Panel" runat="server" HorizontalAlign="Center" />

        <div id="PicturePanel" style="display:none" class="PicturePanel">
                    <asp:HiddenField ID="PictureIndex_Hidden" runat="server" />
                    <asp:HiddenField ID="PicturesCount_Hidden" runat="server" />

                    <table style="width: 100%">
                        <tr>
                            <td></td>
                        </tr>
                        <tr>
                            <td><img id="firstButton" runat="server" alt="First picture" src="Images/BlueCircle-First.png" style="height:30px" onmouseover="this.style.cursor='pointer';" onclick="firstImage();" /></td>
                            <td><img id="prevButton" runat="server" alt="Previous picture" src="Images/BlueCircle-Previous.png" style="height:30px" onmouseover="this.style.cursor='pointer';" onclick="previousImage();" /></td>
                            <td><img id="exitButton" runat="server" alt="Hide picture" src="Images/Exit.bmp" style="height: 30px" onmouseover="this.style.cursor='pointer';" onclick="hideDiv('PicturePanel');" /></td>
                            <td><img id="nextButton" runat="server" alt="Next picture" src="Images/BlueCircle-Next.png" style="height:30px" onmouseover="this.style.cursor='pointer';" onclick="nextImage();" /></td>
                            <td><img id="lastButton" runat="server" alt="Last picture" src="Images/BlueCircle-Last.png" style="height:30px" onmouseover="this.style.cursor='pointer';" onclick="lastImage();" /></td>
                        </tr>
                        <tr>
                            <td></td>
                        </tr>
                        <tr onmousedown="dragStart(event, 'picturePanel');">
                            <td colspan="5">
                                <asp:Label ID="ImageDescription_Label" runat="server" Text="Label" Font-Size="Larger"></asp:Label>
                                <br /><br />
                                <asp:Image ID="Picture_Image" runat="server" CssClass="PictureBox" />
                            </td>
                        </tr>
                    </table>

        </div>

    </div>

</asp:Content>

