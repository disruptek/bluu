
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2015-10-31
## termsOfService: (not provided)
## license: (not provided)
## 
## 
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "automation-account"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_596680 = ref object of OpenApiRestCall_596458
proc url_OperationsList_596682(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_596681(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Automation REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596828 = query.getOrDefault("api-version")
  valid_596828 = validateParameter(valid_596828, JString, required = true,
                                 default = nil)
  if valid_596828 != nil:
    section.add "api-version", valid_596828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596855: Call_OperationsList_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Automation REST API operations.
  ## 
  let valid = call_596855.validator(path, query, header, formData, body)
  let scheme = call_596855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596855.url(scheme.get, call_596855.host, call_596855.base,
                         call_596855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596855, url, valid)

proc call*(call_596926: Call_OperationsList_596680; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Automation REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_596927 = newJObject()
  add(query_596927, "api-version", newJString(apiVersion))
  result = call_596926.call(nil, query_596927, nil, nil, nil)

var operationsList* = Call_OperationsList_596680(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Automation/operations",
    validator: validate_OperationsList_596681, base: "", url: url_OperationsList_596682,
    schemes: {Scheme.Https})
type
  Call_AutomationAccountList_596967 = ref object of OpenApiRestCall_596458
proc url_AutomationAccountList_596969(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutomationAccountList_596968(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of accounts within a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_596984 = path.getOrDefault("subscriptionId")
  valid_596984 = validateParameter(valid_596984, JString, required = true,
                                 default = nil)
  if valid_596984 != nil:
    section.add "subscriptionId", valid_596984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596985 = query.getOrDefault("api-version")
  valid_596985 = validateParameter(valid_596985, JString, required = true,
                                 default = nil)
  if valid_596985 != nil:
    section.add "api-version", valid_596985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596986: Call_AutomationAccountList_596967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of accounts within a given subscription.
  ## 
  let valid = call_596986.validator(path, query, header, formData, body)
  let scheme = call_596986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596986.url(scheme.get, call_596986.host, call_596986.base,
                         call_596986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596986, url, valid)

proc call*(call_596987: Call_AutomationAccountList_596967; apiVersion: string;
          subscriptionId: string): Recallable =
  ## automationAccountList
  ## Retrieve a list of accounts within a given subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596988 = newJObject()
  var query_596989 = newJObject()
  add(query_596989, "api-version", newJString(apiVersion))
  add(path_596988, "subscriptionId", newJString(subscriptionId))
  result = call_596987.call(path_596988, query_596989, nil, nil, nil)

var automationAccountList* = Call_AutomationAccountList_596967(
    name: "automationAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Automation/automationAccounts",
    validator: validate_AutomationAccountList_596968, base: "",
    url: url_AutomationAccountList_596969, schemes: {Scheme.Https})
type
  Call_AutomationAccountListByResourceGroup_596990 = ref object of OpenApiRestCall_596458
proc url_AutomationAccountListByResourceGroup_596992(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutomationAccountListByResourceGroup_596991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of accounts within a given resource group.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596993 = path.getOrDefault("resourceGroupName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "resourceGroupName", valid_596993
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596996: Call_AutomationAccountListByResourceGroup_596990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of accounts within a given resource group.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  let valid = call_596996.validator(path, query, header, formData, body)
  let scheme = call_596996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596996.url(scheme.get, call_596996.host, call_596996.base,
                         call_596996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596996, url, valid)

proc call*(call_596997: Call_AutomationAccountListByResourceGroup_596990;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## automationAccountListByResourceGroup
  ## Retrieve a list of accounts within a given resource group.
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596998 = newJObject()
  var query_596999 = newJObject()
  add(path_596998, "resourceGroupName", newJString(resourceGroupName))
  add(query_596999, "api-version", newJString(apiVersion))
  add(path_596998, "subscriptionId", newJString(subscriptionId))
  result = call_596997.call(path_596998, query_596999, nil, nil, nil)

var automationAccountListByResourceGroup* = Call_AutomationAccountListByResourceGroup_596990(
    name: "automationAccountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts",
    validator: validate_AutomationAccountListByResourceGroup_596991, base: "",
    url: url_AutomationAccountListByResourceGroup_596992, schemes: {Scheme.Https})
type
  Call_AutomationAccountCreateOrUpdate_597011 = ref object of OpenApiRestCall_596458
proc url_AutomationAccountCreateOrUpdate_597013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutomationAccountCreateOrUpdate_597012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update automation account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597040 = path.getOrDefault("automationAccountName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "automationAccountName", valid_597040
  var valid_597041 = path.getOrDefault("resourceGroupName")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "resourceGroupName", valid_597041
  var valid_597042 = path.getOrDefault("subscriptionId")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "subscriptionId", valid_597042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597043 = query.getOrDefault("api-version")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "api-version", valid_597043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update automation account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_AutomationAccountCreateOrUpdate_597011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update automation account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_AutomationAccountCreateOrUpdate_597011;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## automationAccountCreateOrUpdate
  ## Create or update automation account.
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update automation account.
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  var body_597049 = newJObject()
  add(path_597047, "automationAccountName", newJString(automationAccountName))
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597049 = parameters
  result = call_597046.call(path_597047, query_597048, nil, nil, body_597049)

var automationAccountCreateOrUpdate* = Call_AutomationAccountCreateOrUpdate_597011(
    name: "automationAccountCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}",
    validator: validate_AutomationAccountCreateOrUpdate_597012, base: "",
    url: url_AutomationAccountCreateOrUpdate_597013, schemes: {Scheme.Https})
type
  Call_AutomationAccountGet_597000 = ref object of OpenApiRestCall_596458
proc url_AutomationAccountGet_597002(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutomationAccountGet_597001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about an Automation Account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597003 = path.getOrDefault("automationAccountName")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "automationAccountName", valid_597003
  var valid_597004 = path.getOrDefault("resourceGroupName")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "resourceGroupName", valid_597004
  var valid_597005 = path.getOrDefault("subscriptionId")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "subscriptionId", valid_597005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597006 = query.getOrDefault("api-version")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "api-version", valid_597006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597007: Call_AutomationAccountGet_597000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an Automation Account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  let valid = call_597007.validator(path, query, header, formData, body)
  let scheme = call_597007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597007.url(scheme.get, call_597007.host, call_597007.base,
                         call_597007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597007, url, valid)

proc call*(call_597008: Call_AutomationAccountGet_597000;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## automationAccountGet
  ## Get information about an Automation Account.
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597009 = newJObject()
  var query_597010 = newJObject()
  add(path_597009, "automationAccountName", newJString(automationAccountName))
  add(path_597009, "resourceGroupName", newJString(resourceGroupName))
  add(query_597010, "api-version", newJString(apiVersion))
  add(path_597009, "subscriptionId", newJString(subscriptionId))
  result = call_597008.call(path_597009, query_597010, nil, nil, nil)

var automationAccountGet* = Call_AutomationAccountGet_597000(
    name: "automationAccountGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}",
    validator: validate_AutomationAccountGet_597001, base: "",
    url: url_AutomationAccountGet_597002, schemes: {Scheme.Https})
type
  Call_AutomationAccountUpdate_597061 = ref object of OpenApiRestCall_596458
proc url_AutomationAccountUpdate_597063(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutomationAccountUpdate_597062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an automation account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597064 = path.getOrDefault("automationAccountName")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "automationAccountName", valid_597064
  var valid_597065 = path.getOrDefault("resourceGroupName")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "resourceGroupName", valid_597065
  var valid_597066 = path.getOrDefault("subscriptionId")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "subscriptionId", valid_597066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597067 = query.getOrDefault("api-version")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "api-version", valid_597067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update automation account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597069: Call_AutomationAccountUpdate_597061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an automation account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  let valid = call_597069.validator(path, query, header, formData, body)
  let scheme = call_597069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597069.url(scheme.get, call_597069.host, call_597069.base,
                         call_597069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597069, url, valid)

proc call*(call_597070: Call_AutomationAccountUpdate_597061;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## automationAccountUpdate
  ## Update an automation account.
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update automation account.
  var path_597071 = newJObject()
  var query_597072 = newJObject()
  var body_597073 = newJObject()
  add(path_597071, "automationAccountName", newJString(automationAccountName))
  add(path_597071, "resourceGroupName", newJString(resourceGroupName))
  add(query_597072, "api-version", newJString(apiVersion))
  add(path_597071, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597073 = parameters
  result = call_597070.call(path_597071, query_597072, nil, nil, body_597073)

var automationAccountUpdate* = Call_AutomationAccountUpdate_597061(
    name: "automationAccountUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}",
    validator: validate_AutomationAccountUpdate_597062, base: "",
    url: url_AutomationAccountUpdate_597063, schemes: {Scheme.Https})
type
  Call_AutomationAccountDelete_597050 = ref object of OpenApiRestCall_596458
proc url_AutomationAccountDelete_597052(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutomationAccountDelete_597051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an automation account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597053 = path.getOrDefault("automationAccountName")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "automationAccountName", valid_597053
  var valid_597054 = path.getOrDefault("resourceGroupName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "resourceGroupName", valid_597054
  var valid_597055 = path.getOrDefault("subscriptionId")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "subscriptionId", valid_597055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597056 = query.getOrDefault("api-version")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "api-version", valid_597056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597057: Call_AutomationAccountDelete_597050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an automation account.
  ## 
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  let valid = call_597057.validator(path, query, header, formData, body)
  let scheme = call_597057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597057.url(scheme.get, call_597057.host, call_597057.base,
                         call_597057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597057, url, valid)

proc call*(call_597058: Call_AutomationAccountDelete_597050;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## automationAccountDelete
  ## Delete an automation account.
  ## http://aka.ms/azureautomationsdk/automationaccountoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597059 = newJObject()
  var query_597060 = newJObject()
  add(path_597059, "automationAccountName", newJString(automationAccountName))
  add(path_597059, "resourceGroupName", newJString(resourceGroupName))
  add(query_597060, "api-version", newJString(apiVersion))
  add(path_597059, "subscriptionId", newJString(subscriptionId))
  result = call_597058.call(path_597059, query_597060, nil, nil, nil)

var automationAccountDelete* = Call_AutomationAccountDelete_597050(
    name: "automationAccountDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}",
    validator: validate_AutomationAccountDelete_597051, base: "",
    url: url_AutomationAccountDelete_597052, schemes: {Scheme.Https})
type
  Call_KeysListByAutomationAccount_597074 = ref object of OpenApiRestCall_596458
proc url_KeysListByAutomationAccount_597076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KeysListByAutomationAccount_597075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the automation keys for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597077 = path.getOrDefault("automationAccountName")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "automationAccountName", valid_597077
  var valid_597078 = path.getOrDefault("resourceGroupName")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "resourceGroupName", valid_597078
  var valid_597079 = path.getOrDefault("subscriptionId")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "subscriptionId", valid_597079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597080 = query.getOrDefault("api-version")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "api-version", valid_597080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597081: Call_KeysListByAutomationAccount_597074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the automation keys for an account.
  ## 
  let valid = call_597081.validator(path, query, header, formData, body)
  let scheme = call_597081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597081.url(scheme.get, call_597081.host, call_597081.base,
                         call_597081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597081, url, valid)

proc call*(call_597082: Call_KeysListByAutomationAccount_597074;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## keysListByAutomationAccount
  ## Retrieve the automation keys for an account.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597083 = newJObject()
  var query_597084 = newJObject()
  add(path_597083, "automationAccountName", newJString(automationAccountName))
  add(path_597083, "resourceGroupName", newJString(resourceGroupName))
  add(query_597084, "api-version", newJString(apiVersion))
  add(path_597083, "subscriptionId", newJString(subscriptionId))
  result = call_597082.call(path_597083, query_597084, nil, nil, nil)

var keysListByAutomationAccount* = Call_KeysListByAutomationAccount_597074(
    name: "keysListByAutomationAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/listKeys",
    validator: validate_KeysListByAutomationAccount_597075, base: "",
    url: url_KeysListByAutomationAccount_597076, schemes: {Scheme.Https})
type
  Call_StatisticsListByAutomationAccount_597085 = ref object of OpenApiRestCall_596458
proc url_StatisticsListByAutomationAccount_597087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/statistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StatisticsListByAutomationAccount_597086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the statistics for the account.
  ## 
  ## http://aka.ms/azureautomationsdk/statisticsoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597089 = path.getOrDefault("automationAccountName")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "automationAccountName", valid_597089
  var valid_597090 = path.getOrDefault("resourceGroupName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "resourceGroupName", valid_597090
  var valid_597091 = path.getOrDefault("subscriptionId")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "subscriptionId", valid_597091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597092 = query.getOrDefault("api-version")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "api-version", valid_597092
  var valid_597093 = query.getOrDefault("$filter")
  valid_597093 = validateParameter(valid_597093, JString, required = false,
                                 default = nil)
  if valid_597093 != nil:
    section.add "$filter", valid_597093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597094: Call_StatisticsListByAutomationAccount_597085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the statistics for the account.
  ## 
  ## http://aka.ms/azureautomationsdk/statisticsoperations
  let valid = call_597094.validator(path, query, header, formData, body)
  let scheme = call_597094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597094.url(scheme.get, call_597094.host, call_597094.base,
                         call_597094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597094, url, valid)

proc call*(call_597095: Call_StatisticsListByAutomationAccount_597085;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## statisticsListByAutomationAccount
  ## Retrieve the statistics for the account.
  ## http://aka.ms/azureautomationsdk/statisticsoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597096 = newJObject()
  var query_597097 = newJObject()
  add(path_597096, "automationAccountName", newJString(automationAccountName))
  add(path_597096, "resourceGroupName", newJString(resourceGroupName))
  add(query_597097, "api-version", newJString(apiVersion))
  add(path_597096, "subscriptionId", newJString(subscriptionId))
  add(query_597097, "$filter", newJString(Filter))
  result = call_597095.call(path_597096, query_597097, nil, nil, nil)

var statisticsListByAutomationAccount* = Call_StatisticsListByAutomationAccount_597085(
    name: "statisticsListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/statistics",
    validator: validate_StatisticsListByAutomationAccount_597086, base: "",
    url: url_StatisticsListByAutomationAccount_597087, schemes: {Scheme.Https})
type
  Call_UsagesListByAutomationAccount_597098 = ref object of OpenApiRestCall_596458
proc url_UsagesListByAutomationAccount_597100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesListByAutomationAccount_597099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the usage for the account id.
  ## 
  ## http://aka.ms/azureautomationsdk/usageoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597101 = path.getOrDefault("automationAccountName")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "automationAccountName", valid_597101
  var valid_597102 = path.getOrDefault("resourceGroupName")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "resourceGroupName", valid_597102
  var valid_597103 = path.getOrDefault("subscriptionId")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "subscriptionId", valid_597103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597104 = query.getOrDefault("api-version")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "api-version", valid_597104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597105: Call_UsagesListByAutomationAccount_597098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the usage for the account id.
  ## 
  ## http://aka.ms/azureautomationsdk/usageoperations
  let valid = call_597105.validator(path, query, header, formData, body)
  let scheme = call_597105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597105.url(scheme.get, call_597105.host, call_597105.base,
                         call_597105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597105, url, valid)

proc call*(call_597106: Call_UsagesListByAutomationAccount_597098;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## usagesListByAutomationAccount
  ## Retrieve the usage for the account id.
  ## http://aka.ms/azureautomationsdk/usageoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597107 = newJObject()
  var query_597108 = newJObject()
  add(path_597107, "automationAccountName", newJString(automationAccountName))
  add(path_597107, "resourceGroupName", newJString(resourceGroupName))
  add(query_597108, "api-version", newJString(apiVersion))
  add(path_597107, "subscriptionId", newJString(subscriptionId))
  result = call_597106.call(path_597107, query_597108, nil, nil, nil)

var usagesListByAutomationAccount* = Call_UsagesListByAutomationAccount_597098(
    name: "usagesListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/usages",
    validator: validate_UsagesListByAutomationAccount_597099, base: "",
    url: url_UsagesListByAutomationAccount_597100, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
