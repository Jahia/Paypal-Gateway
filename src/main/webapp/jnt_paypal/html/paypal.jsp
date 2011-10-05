<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<script type="text/javascript">
function testField(field) {
    var regExpr = new RegExp("^\d*\.?\d*$");
    if (!regExpr.test(field.value)) {
      // Case of error
      field.value = "";
    }
}

</script>

<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
	<input type="hidden" name="business" value="${currentNode.properties.paypaluser.string}">
	<input type="hidden" name="lc" value="${currentNode.properties.countrycode.string}">
	<input type="hidden" name="item_name" value="${currentNode.properties.item_name.string}">
	<input type="hidden" name="item_number" value="${currentNode.properties.item_number.integer}">		
	<c:set var="inputtype" value="hidden" />
	<c:set var="inputreadonly" value="" />
	<c:set var="amountValue" value="${currentNode.properties.amount.double}" />
	<c:if test="${!empty param.price && !empty currentNode.properties.allowrequestparamprice && currentNode.properties.allowrequestparamprice.boolean}">
		<%
		  try{
		    Double.parseDouble(request.getParameter("price"));
		  %>
		<c:set var="amountValue" value="${param.price}" />
		  <%}catch(Exception ex) {
		       //use the default value of amount
		    } %>
	</c:if>		
	<c:if test="${!empty currentNode.properties.displayAmountInputField && currentNode.properties.displayAmountInputField.boolean}">
		<c:set var="inputtype" value="text" />
		<c:if test="${!empty currentNode.properties.amountReadOnly && currentNode.properties.amountReadOnly.boolean}">
		   <c:set var="inputreadonly" value="readonly " />	
		</c:if>
		 <fmt:message key="jnt_amount.label"/>
	</c:if>			
	<input type="${inputtype}" name="amount" value="${amountValue}" ${inputreadonly} style="text-align:right" onblur="testField(this);"/>
	<c:if test="${!empty currentNode.properties.displayAmountInputField && currentNode.properties.displayAmountInputField.boolean}">
		${currentNode.properties.currency_code.string}<br/>
	</c:if>
	<input type="hidden" name="no_note" value="0">
	<input type="hidden" name="currency_code" value="${currentNode.properties.currency_code.string}">	
	
	<c:if test="${currentNode.properties.typeOfPayment.string == 'donate'}">
		<fmt:message key="donate.button.image" var="donatebutton"/>
		<c:if test="${empty donatebutton || fn:startsWith(donatebutton, '???')}">	
			 <c:set var="donatebutton" value="btn_donateCC_LG_en.gif" />	
		</c:if>			
		
		<input type="hidden" name="cmd" value="_donations">

		<input type="hidden" name="bn" value="PP-DonationsBF:btn_donateCC_LG.gif:NonHostedGuest">
		<input type="image" src="<c:url value='${url.currentModule}/img/${donatebutton}'/>" border="0" name="submit" alt="<fmt:message key="label.alt.donate.button"/>">
		<img alt="" border="0" src="<c:url value='${url.currentModule}/img/pixel.gif'/>" width="1" height="1">
	</c:if>
	<c:if  test="${currentNode.properties.typeOfPayment.string == 'billing'}">
		<fmt:message key="billing.button.image" var="billingbutton"/>
		<c:if test="${empty billingbutton || fn:startsWith(billingbutton, '???')}">	
			 <c:set var="billingbutton" value="btn_paynowCC_LG_en.gif" />	
		</c:if>	
		
		<input type="hidden" name="cmd" value="_xclick">
		<input type="hidden" name="button_subtype" value="services">
		<input type="hidden" name="bn" value="PP-BuyNowBF:btn_paynowCC_LG.gif:NonHostedGuest">
		<%/*<table><tr><td><input type="hidden" name="on0" value="freetext">freetext</td></tr><tr><td><input type="text" name="os0" maxlength="200"></td></tr>	</table>*/%>
		<input type="image" src="<c:url value='${url.currentModule}/img/${billingbutton}'/>" border="0" name="submit" alt="<fmt:message key="label.alt.billing.button"/>"><img alt="" border="0" src="<c:url value='${url.currentModule}/img/pixel.gif'/>" width="1" 	height="1">
	</c:if>	
</form>