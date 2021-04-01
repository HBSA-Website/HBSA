<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="CompetitionsResults.aspx.vb" Inherits="HBSA_Web_Application.CompetitionsResults" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .txtBox {}

       .hoverDiv {
            border-style: solid; 
            border-width: 1px; 
            padding: 5px; 
            position:absolute; 
            margin-left: 50px; 
            margin-top: 0px; 
            display:none; 
            background-color: #FFFFCC;
        }

    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" >

    <script type="text/javascript">
    function loadHoverDiv(DivID) {

        document.getElementById(DivID).style.display = "block";
    
    }

    function hideHoverDiv(DivID) {

        document.getElementById(DivID).style.display = "none";
    }
</script>

    <input type="hidden" name="_ButtonClicked" id="_ButtonClicked" value="" />
    <input type="hidden" name="_BoxChanged" id="_BoxChanged" value="" />

    <div style="text-align:left; ">
        <h3>Competitions</h3>
        <table>
            <tr>
                <td>
                    <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                        <table style="text-align:left" >
                            <tr>
                                <td style="text-align:right">Select a competition:</td>
                                <td>
                                    <asp:DropDownList ID="Competitions_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
        <asp:Literal ID="Comment_Literal" runat="server"></asp:Literal>
        <asp:Table ID="Competition_Table" runat="server"></asp:Table>
    </div>
       
          <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditNote" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:600px; top: 274px; left:100px;
                                   ">
                <%--<table style="width: 100%; height: 100%">
                    <tr>
                        <td style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid;">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Match&nbsp;Notes"></asp:Literal></strong></td>
                    </tr>
                </table>--%>
                <table 
                    style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td colspan="5">
                                <div id="Div1" style="display:block; text-align: left;">
                                <br />
                                    <div style="width:100%; text-align:center; font-size: 10pt; color: #000099;">
                                        <asp:Literal ID="Edit_Literal" runat="server"></asp:Literal>
                                    </div>
                                    <div style="width:100%;">
                                      <asp:TextBox ID="ID_TextBox" runat="server" Visible="false"></asp:TextBox>
                                  </div>  

                                  <div>
                                <table>
                                    <tr>
                                        <th style="text-align:right; vertical-align:top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Notes:</th>
                                        <td><asp:TextBox ID="Note_TextBox" runat="server" CssClass="txtBox" Width="478px" TextMode="MultiLine" Height="97px"></asp:TextBox></td>
                                    </tr>
                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="SubmitPlayer_Button" runat="server" Text="Submit" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="Close_Button" runat="server" Text="Close" />
                                    </td>
                                 </tr>
                                    
                                </table>
                              </div>
                            </div>
                        </td>
                    </tr>
                </table>
  
            </div>
        </asp:Panel>

</asp:Content>
