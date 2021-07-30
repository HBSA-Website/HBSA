<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="EntryForm.aspx.vb" Inherits="HBSA_Web_Application.EntryForm" ClientIDMode="Static"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

	<div style="border: 1px solid #000000; font-family: Verdana; color:Green; text-align:center; background-color:#ccffcc; font-size: 11pt;">
		<b>Huddersfield Billiards &amp; Snooker Association<br />
			<asp:Literal ID="Season_Literal" runat="server"></asp:Literal>&nbsp;Team Entries Invitation Form<br />
		ENTRIES ACCEPTED SUBJECT TO HBSA LEAGUE RULES</b>
		<br />
		<hr />

			<asp:Literal ID="Head_Literal" runat="server"></asp:Literal>

		<hr />
		
		<asp:ScriptManager ID="ToolkitScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

		<asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
			<ProgressTemplate>
				<div id="Loading" style="position: fixed; left:440px;top:260px">
					<asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
				</div>
			</ProgressTemplate>
		</asp:UpdateProgress>

        <asp:HiddenField ID="userHiddenField" runat="server" Value="" />
        <asp:HiddenField ID="ClubLoginIDHiddenField" runat="server" Value="" />
        <asp:HiddenField ID="adminHiddenField" runat="server" Value="" />
        <asp:HiddenField ID="clubSaveButtonHiddenField" runat="server" Value="" />
        <asp:HiddenField ID="leagueIDHiddenField" runat="server" Value="" />
		
		<div style="text-align: left">
			<asp:Literal ID="Club_Selector_Literal" runat="server"></asp:Literal><br />
		</div>


        
		<asp:UpdatePanel ID="Club_UpdatePanel" runat="server">

            <ContentTemplate>

                <asp:Panel ID="Acceptance_Panel" runat="server" Visible="true">
                    <div style="padding: 4px; border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 12Pt; color: maroon; vertical-align: top; text-align: left; position: absolute; left: 300px; top: 300px; width: 50%; color: #CC0000; background-color: #FFFF99;">
                        <asp:Literal ID="AcceptanceCopy_Literal" runat="server"></asp:Literal><br />
                        <asp:CheckBox ID="Accept_CheckBox" runat="server" Text=" I confirm I have read the statement above and will act upon it." TextAlign="Right" ForeColor="#003399" Font-Underline="True" Font-Size="14pt" Font-Bold="True" />
                        <br />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Accept_Button" runat="server" Text="OK, I accept" /><br />
                        <br />
                    </div>
                </asp:Panel>

                <asp:Panel ID="Club_Panel" runat="server" Visible="true">
                    <div style="text-align: left">
                        <span style="font-size: 11pt; font-weight: bold; color: #FF0000">&nbsp;&nbsp;&nbsp;&nbsp;Club Affiliation Fee £<asp:Literal ID="Club_Fee_Literal" runat="server"></asp:Literal>
                        </span>
                        <br />
                        <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" Style="text-align: left"></asp:DropDownList>
                        <asp:Button ID="Show_Button" runat="server" Text="Show all entry form details" Visible="false" />
                        <br />
                        <asp:Literal ID="Club_WIP_Literal" runat="server"></asp:Literal>


                        <div id="PayNotice2" runat="server" visible="false">
                        </div>

                        <table id="ClubDetails_Table" runat="server">
                            <tr>
                                <th style="text-align: right">Club Name:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_Name_TextBox" runat="server" Width="224px" MaxLength="50"></asp:TextBox></td>
                                <th style="text-align: right"></th>
                                <%--<td><asp:Literal ID="Club_ID" runat="server" Visible="False"></asp:Literal></td>--%>
                            </tr>
                            <tr>
                                <th style="text-align: right">Address 1:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_Addr1_TextBox" runat="server" Width="224px" MaxLength="50"></asp:TextBox></td>
                                <th style="text-align: right">Contact:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_Contact_TextBox" runat="server" MaxLength="104"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th style="text-align: right">Address 2:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_Addr2_TextBox" runat="server" Width="224px" MaxLength="50"></asp:TextBox></td>
                                <th style="text-align: right">Telephone:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_Telephone_TextBox" runat="server" MaxLength="20"
                                        onkeyup="this.value=this.value.replace(/[^1234567890 ]/g,'')"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th style="text-align: right">Post Code:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_PostCode_TextBox" runat="server" Width="224px" MaxLength="10"></asp:TextBox></td>
                                <th style="text-align: right">Mobile:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_Mobile_TextBox" runat="server" MaxLength="20"
                                        onkeyup="this.value=this.value.replace(/[^1234567890 ]/g,'')"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th style="text-align: right">No of Tables:</th>
                                <td>
                                    <asp:TextBox CssClass="txtBox" ID="Club_NoTables_TextBox" runat="server" Width="20px" MaxLength="1"
                                        onkeyup="this.value=this.value.replace(/[^1234567890]/g,'')"></asp:TextBox></td>
                                <th style="text-align: right">Club Login eMail:</th>
                                <td>
                                    <asp:Label Style="padding: 2px;" ID="Club_Email_Label" runat="server" Width="224px" Font-Size="10pt" ForeColor="#666666" BackColor="White">&nbsp;</asp:Label></td>
                            </tr>
                        </table>

                        <asp:Button ID="Club_Save_Button" runat="server" Text="Save Club Details" Width="168px" /><br />
                        <asp:Literal ID="Club_Status_Literal" runat="server"></asp:Literal>

                    </div>
                </asp:Panel>
            </ContentTemplate>

        </asp:UpdatePanel>

        <asp:UpdatePanel ID="Teams_UpdatePanel" runat="server">

	<ContentTemplate>    
		
<script type = "text/javascript">

    function autoComplete1_OnClientPopulating(sender, args) {
        sender.set_contextKey(document.getElementById("<%=Team_League_DropDownList.ClientID%>").value);
    }

</script>

<style type="text/css">
  .BigCheckBox input {width:20px; height:20px;}
</style>

<br />
	<asp:Panel ID="Teams_Panel" runat="server">

	  <table style="text-align:left; vertical-align:top; width:100%" >
			<tr>
				<td colspan="2" style="font-size: 11pt; text-align:left; background-color:white; color:black" ><b>Teams:</b> 
                    <br />
                    Work through each team and check/change the details then click &#39;Save this team&#39;.<br />
                    <br />
                    For new teams Click &#39;Add another team&#39; and enter its details then click &#39;Save this team&#39;.
                    <br />
                    <br />
                    To delete a team click &#39;delete&#39; next to the team.
					<i>(If there are any players registered to the team select it then delete each of its registered players below.)</i><br />
					<b>Note that if you don&#39;t delete an unwanted team it will be registered and charged for.</b><br />
                    <br />
                    <span style="color:blue; font-size:larger;"> Select each team and work through the players below.</span></td>
			</tr>
			<tr style="vertical-align:top">
				<td>
					
					<asp:GridView ID="Teams_GridView" runat="server"
									BorderStyle="Solid" BorderWidth="1px" CellPadding="2" ShowHeader="false"
									AllowSorting="false" EmptyDataText="Click Add a team" Font-Size="8pt">
									<Columns>
										<asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowSelectButton="True" />
									</Columns>
									<AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
									<RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" Font-Size="12pt" />
									<%--<SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" Font-Size="12pt"  />--%>
								</asp:GridView>
					<div id="divConfirmDeleteTeam" runat="server" style="display:none;border:1px solid black; background-color:white; color:red;">
						Do really want to delete <asp:Literal ID="DeleteTeam_Literal" runat="server"></asp:Literal> ?<br />
						Click Yes to delete this team or Click No<br />
                        <asp:Button ID="DeleteTeam_Button" runat="server" Text="Yes" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<asp:Button ID="KeepTeam_Button" runat="server" Text="No " />
					</div>
					<asp:Literal ID="Teams_Literal" runat="server"></asp:Literal>
					<br />
					<asp:Button ID="Team_Add_Button" runat="server" Text="Add another Team" Width="165px" />
					<br /><br />
				</td>
				<td style="text-align:left;">
					<table>
						<tr style="color: #FF0000"><th>Team Fee</th><td>
							<asp:Literal ID="Team_Fee_Literal" runat="server"></asp:Literal></td></tr>
						<tr><th style="text-align:right;">League:</th>
							<td><asp:DropDownList ID="Team_League_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList></td>
						</tr>
						<tr><th style="text-align:right;">Team&nbsp;letter:</th>
							<td><asp:DropDownList ID="Team_Letter_DropDownList" runat="server" AutoPostBack="true">
								<asp:ListItem Value="0">**Select**</asp:ListItem>
								<asp:ListItem Value=" ">(none)</asp:ListItem>
								<asp:ListItem>A</asp:ListItem>
								<asp:ListItem>B</asp:ListItem>
								<asp:ListItem>C</asp:ListItem>
								<asp:ListItem>D</asp:ListItem>
								<asp:ListItem>E</asp:ListItem>
								<asp:ListItem>F</asp:ListItem>
								</asp:DropDownList></td>
						</tr>
						<tr><th style="text-align:right;">Captain/Contact:</th>
							<td><asp:Label ID="Team_ContactCaptain_Label" Style="font-size: 10pt; text-align: left; background-color: white; color: black" runat="server"></asp:Label>
                                <asp:HiddenField ID="Team_ContactCaptain_PlayerID_HiddenField" runat="server" />
							</td>
						</tr>
						<tr>
							<td></td>
							<td >
								<asp:Button ID="Team_Save_Button" runat="server" Text="Save this team" Visible="false" />
							</td>
						</tr>
						<tr>
							<td colspan="2" style="font-size: 9pt">
								<asp:Literal ID="Team_Literal" runat="server"></asp:Literal>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
				
			<table style="text-align:left; vertical-align:top;" >
			<tr>
				<td colspan="2" style="font-size: 11pt; text-align:left; background-color:white; color:black;" ><b><asp:Literal ID="teamLiteral" runat="server"></asp:Literal> team players:</b>  
                    <br />
                    Check each player.&nbsp; If the player is to be registered tick his/her ReRegister box. Note that players that are not ticked to be reregistered will be greyed out and will not be available in the upcoming season.<br />
                    <br />
                    To add another team player click &#39;Add/Find a player&#39; and follow instructions.<br /> <br />
			</tr>
			<th style="vertical-align:top">
                <td>
                    <asp:Button ID="Player_Find_Button" runat="server" Text="Add/Find a player" />
                    &nbsp;&nbsp; <br />
                    <br />
                    <span style='color: red; font-size:larger;font-weight:bold;'>
                        <asp:Literal ID="Player_Error_Literal" runat="server" Text=""></asp:Literal></span>
                        <br />
                        <span style="color:blue;font-size:larger;"> At Least 5 players per team must be registered.</span>
								 <br />
                        <asp:GridView ID="Players_GridView" runat="server"
                            BorderStyle="Solid" BorderWidth="1px" CellPadding="2" EmptyDataText="Click Add a player" Font-Size="8pt"
                            AutoGenerateEditButton="True" AutoGenerateDeleteButton="True">
                            <Columns>
                                <asp:TemplateField HeaderText="ReRegister">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="ReRegister_Checkbox"
                                            AutoPostBack="true"
                                            OnCheckedChanged="ReRegister_Checkbox_Changed" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Captain">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="Captain_Checkbox"
                                            AutoPostBack="true"
                                            OnCheckedChanged="Captain_Checkbox_Changed" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                            <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
                            <%--<SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />--%>
                        </asp:GridView></td>
                </tr>
                </table>					
			 
				<div class="privacy">
                    <u>IMPORTANT - PLEASE READ CAREFULLY</u>
                    <ol>
						<li>Personal contact details as above are used only for allowing players to contact each other (e.g. when arranging competitions &amp; for matters relating to league games) and for occasional important communication from HBSA officials.</li>
                    <li>PLEASE TICK THE BOX to confirm that all players listed above are aware that their email addresses and phone numbers (as provided above) will be permanently available on our website and their permission has been given to use their contact details for the above purposes.</li>
					<li>If any of your players DO NOT wish their personal details to be available on our website, then please EDIT their player record above and REMOVE their email addresses /phone number, as appropriate.</li>
					<li>Please note that contact details can be added, removed or changed at any point during the season in line with each player’s preferences.</li>
					</ol>

                    <asp:CheckBox CssClass="BigCheckBox" ID="privacyCheckBox"
                        Text="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tick here to  agree / acknowledge points 1-4 above." runat="server" />
				 <br /><br />When all teams have been checked, and are as required, click this button:
				    <br />
				 <br />
				    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:Button ID="submitEntryForm_Button" runat="server" Text="Submit the entry form." Font-Size="Large" Width="205px" />
                    &nbsp;&nbsp;<asp:Literal ID="submitErrorMsg" runat="server"></asp:Literal>
				</tr>
			</table>
		</asp:Panel>

		<asp:Panel ID="Player_Edit_Panel" runat="server" Visible="true">
			<div id="divRegisterPlayer" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
								   text-align: left; position: fixed; left:300px; top: 300px; color: #000000; background-color: #EEFFEE;">
				<table style="width: 100%;">
					<tr>
						<td onmousedown="dragStart(event, 'divRegisterPlayer')" 
							onmouseover="this.style.cursor='pointer';" 
							style="border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid;
							background-image:url('images/menuBarBG.gif'); font-size: 10pt;">
							<strong>
                                <asp:Literal ID="AddEdit_Literal" runat="server"></asp:Literal></strong></td>
					</tr>
				</table>
				<table style="border-spacing:2px; font-size:9pt; width:100%; vertical-align: top;">
					<tr>
						<td>
						   <div style="font-size:10pt; display:block; text-align: left;">
							   Enter player details here and submit them. <br />
							   Please use full first names and initials of secondary forenames where they exist.  <br />
							   Also use capitals as it makes it easier for us to administer.
							   <br />
							   <span style="color:red"><asp:Literal ID="Player_Status_Literal" runat="server" Text=""></asp:Literal></span>

							 <div>
							<table>
									<tr>
										<th>First Name</th><th>Inits</th><th>Surname</th><th>Handicap</th>
									 </tr>
									<tr>
										<td><asp:TextBox ID="Player_Forename_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px" MaxLength="50"></asp:TextBox></td>
										<td><asp:TextBox ID="Player_Inits_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="32px" MaxLength="4"></asp:TextBox></td>
										<td><asp:TextBox ID="Player_Surname_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px" MaxLength="50"></asp:TextBox></td>
										<td>
                                            <input id="Player_Handicap_Text" type="text" runat="server" style="text-align: center; background-color: #FFFFCC; width: 32px"
                                                readonly onclick="loadDiv('divHCapMsg');" onmouseover="this.style.cursor='pointer';" />
										</td>
								 </tr>
             					 <tr>
									  <td colspan="4">
                                    		<div id="divHCapMsg" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 9Pt;  display:none;
				                                  text-align: left; color:red; background-color: #ccffcc;" onclick="hideDiv('divHCapMsg');">
								                <strong>Warning:</strong><br />
												Handicaps and tags cannot be changed on the entry form.<br />
												If either the handicap or the tag is incorrect <a href="Contact.aspx" target="_blank"> contact the league secretary.</a>
										    </div>
             					     </td>
             					 </tr>
							 </table>
							 <table>
								 <tr><th>Tag</th>
									   <td style="vertical-align:top" >
                                           <input id="Player_Tag_Value" type="hidden" runat="server" />
										   <input id="Player_Tag_Text" type="text" runat="server" style="text-align: center; background-color: #FFFFCC;"
                                               readonly onclick="loadDiv('divHCapMsg');" onmouseover="this.style.cursor='pointer';" />
									   <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="Player_Over70_CheckBox" runat="server" Text="Over 80" Font-Bold="True" TextAlign="Left" /></td>

								 </tr>
							</table>
							<table>
								 <tr>
									   <th>Email</th><th>Telephone</th>
								 </tr>
								 <tr>
										<td><asp:TextBox ID="Player_email_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="250px"></asp:TextBox></td>
										<td><asp:TextBox ID="Player_TelNo_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" MaxLength="20" Width="144px"
														 onkeyup="this.value=this.value.replace(/[^1234567890 ]/g,'')"></asp:TextBox></td>
								 </tr>

							</table>
							<table style="width:100%;">
								 <tr>
									<td style="text-align:center;">
										<asp:Button ID="Player_Submit_Button" runat="server" Text="Submit" />
									</td>
									<td style="text-align:center">
										<asp:Button ID="Player_Cancel_Button" runat="server" Text="Cancel" />
									</td>
								 </tr>
									
								</table>
							  </div>
							</div>

			<asp:Panel ID="Player_Similar_Panel" runat="server" Visible="false">
			<div id="divSimilarPlayer" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 9Pt; display:block; vertical-align: top; 
								              text-align: left; color: #000000; background-color: #EEFFEE; padding:4px;">
				<div style="padding:4px; color: #0000FF">
					The Player(s) shown below have very similar names to the one you are adding.<br />
					Check that the player you are trying to add is not one of them.<br /> <br />
					If there&#39;s an error in the data above, correct it and Click Add this Player,<br />
					<br />
                    If one of them is the player you are adding <span style="font-size: larger; font-weight: bold; color: darkgreen"">click the Transfer</span> link at the left of the player.<br />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This will transfer that player from the other team to yours.<br />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:red">Be sure that the other club/team agrees that you can do this.</span>
				    <br />
                    <br />
                    If none of them is the same player click the Add player button below, or click Cancel above.<br />
				</div>
				<asp:GridView ID="Player_Similar_GridView" runat="server"
									BorderStyle="Solid" BorderWidth="1px" CellPadding="2" Font-Size="8pt">
									<AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
									<Columns>
										<asp:CommandField SelectText="Transfer" ShowSelectButton="True" >
										<ItemStyle Font-Bold="True" Font-Size="11pt" BackColor="#CCCCCC" BorderColor="#666666" BorderStyle="Ridge" BorderWidth="1px" />
										</asp:CommandField>
									</Columns>
									<HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
									<RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
				</asp:GridView>
				<asp:Button ID="Player_Similar_Add_Button" runat="server" Text="Add player" BorderStyle="Outset" Font-Size="10pt" BorderWidth="1px" />

			</div>

		</asp:Panel>
 

						</td>
					</tr>
				</table>
  
	        </div>

		</asp:Panel>

		<asp:Panel ID="Player_Transfer_Panel" runat="server" Visible="false">
			<div id="divTransferPlayer" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
								   text-align: left; position: fixed; left:10%; top: 400px; max-width:80%; color: #000000; background-color: #EEFFEE;">
				<table style="width: 100%;">
					<tr>
						<td onmousedown="dragStart(event, 'divTransferPlayer')" 
							onmouseover="this.style.cursor='pointer';" 
							style="border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid;
							background-image:url('images/menuBarBG.gif'); font-size: 10pt;">
							<strong>Find&nbsp;a&nbsp;player</strong></td>
					</tr>
				</table>
 
				<table style="font-size:9pt; width:100%; vertical-align: top;">
					<tr>
						<td style="padding:4px">
						   <div style="font-size:10pt; display:block; text-align: left;">
							   <br />
							   Enter the first few characters of a player&#39;s first, and/or surname. As you enter characters suggestions will appear below.&nbsp; As further characters are entered fewer names will appear.<br />When you see the one you want select (click) it, then click &quot;Add selected player to team&quot;.
							   <br /><span style="color:red">N.B. If the selected player is already a member of another team it is your responsibility to agree with the other team 
								   that they are willing to release the player, and that the player is willing to move.</span><br />
							   If you cannot find the player click &quot;Add a Brand New League player&quot;.<br /><br />
							   <div>   
                                   &nbsp;&nbsp;<img alt="" src="images/LongArrow.png" height="20" />
								   <asp:TextBox ID="Player_Transfer_TextBox" runat="server" BackColor="#FFFFCC" Width="300px"></asp:TextBox>
								   <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_Transfer_TextBox" DelimiterCharacters="" 
											  MinimumPrefixLength="3" EnableCaching="true" UseContextKey="True"
											  OnClientPopulating="autoComplete1_OnClientPopulating"
											  ServiceMethod="Player_Transfer_SuggestPlayers" CompletionInterval="10"
											  CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" 
											  CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>
									&nbsp;&nbsp;Then select the player you want from the list.	
							   </div>
							   <br />
							  <div style="text-align: center;">
							  	   <asp:Button ID="Player_Transfer_GetByName_Button" runat="server" Text="Add selected player to team" />
								   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
								   <asp:Button ID="Player_Transfer_Cancel_Button" runat="server" Text="Cancel" />
								  <br /><br />
								   Can&#39;t find the player? Click here to enter a new player - please only do this as a last resort and only for BRAND NEW players.  
								  <asp:Button ID="Player_Add_Button" runat="server" Text="Add a Brand New League player" />
								  <br /><span style="color:red;"><asp:Literal ID="Player_Transfer_Literal" runat="server" Text=""></asp:Literal></span>
							  </div>
						</td>
					</tr>
				</table>
  
			</div>

		</asp:Panel>

	</ContentTemplate>

	</asp:UpdatePanel>

	</div>
</asp:Content>
