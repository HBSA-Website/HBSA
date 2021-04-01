<%@ Page Title="PayPal - Error Page" Language="VB" MasterPageFile="~/MasterPage.master"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<script runat="server">

</script>
    <div style="text-align:center;width:100%">
        
        <h4><span style="color:red">A problem occurred whilst processing your PayPal transaction.</span></h4>
        <a href='contact.aspx'>Please contact us (click here) with the information below.</a><br /><br />
                
		<table>
			<tr>
				<td class="field"></td>
				<td><%=Request.QueryString.Get("ErrorCode")%></td>
			</tr>
			
			<tr>
				<td class="field"></td>
				<td><%=If(Request.QueryString.Get("Desc") Is Nothing, "", Request.QueryString.Get("Desc").Replace("~|~", "<br/>"))%></td>
			</tr>
			
			<tr>
				<td class="field"></td>
				<td><%=If(Request.QueryString.Get("Desc2") Is Nothing, "", Request.QueryString.Get("Desc2").Replace("~|~", "<br/>"))%></td>
			</tr>

		</table>

    </div>

</asp:Content>