
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2018-01-15
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
  macServiceName = "automation-dscNodeConfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DscNodeConfigurationListByAutomationAccount_596680 = ref object of OpenApiRestCall_596458
proc url_DscNodeConfigurationListByAutomationAccount_596682(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/nodeConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeConfigurationListByAutomationAccount_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of dsc node configurations.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
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
  var valid_596843 = path.getOrDefault("automationAccountName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "automationAccountName", valid_596843
  var valid_596844 = path.getOrDefault("resourceGroupName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "resourceGroupName", valid_596844
  var valid_596845 = path.getOrDefault("subscriptionId")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "subscriptionId", valid_596845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of rows to take.
  ##   $skip: JInt
  ##        : The number of rows to skip.
  ##   $inlinecount: JString
  ##               : Return total rows.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596846 = query.getOrDefault("api-version")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "api-version", valid_596846
  var valid_596847 = query.getOrDefault("$top")
  valid_596847 = validateParameter(valid_596847, JInt, required = false, default = nil)
  if valid_596847 != nil:
    section.add "$top", valid_596847
  var valid_596848 = query.getOrDefault("$skip")
  valid_596848 = validateParameter(valid_596848, JInt, required = false, default = nil)
  if valid_596848 != nil:
    section.add "$skip", valid_596848
  var valid_596849 = query.getOrDefault("$inlinecount")
  valid_596849 = validateParameter(valid_596849, JString, required = false,
                                 default = nil)
  if valid_596849 != nil:
    section.add "$inlinecount", valid_596849
  var valid_596850 = query.getOrDefault("$filter")
  valid_596850 = validateParameter(valid_596850, JString, required = false,
                                 default = nil)
  if valid_596850 != nil:
    section.add "$filter", valid_596850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596877: Call_DscNodeConfigurationListByAutomationAccount_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of dsc node configurations.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_596877.validator(path, query, header, formData, body)
  let scheme = call_596877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596877.url(scheme.get, call_596877.host, call_596877.base,
                         call_596877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596877, url, valid)

proc call*(call_596948: Call_DscNodeConfigurationListByAutomationAccount_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: int = 0; Skip: int = 0;
          Inlinecount: string = ""; Filter: string = ""): Recallable =
  ## dscNodeConfigurationListByAutomationAccount
  ## Retrieve a list of dsc node configurations.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of rows to take.
  ##   Skip: int
  ##       : The number of rows to skip.
  ##   Inlinecount: string
  ##              : Return total rows.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_596949 = newJObject()
  var query_596951 = newJObject()
  add(path_596949, "automationAccountName", newJString(automationAccountName))
  add(path_596949, "resourceGroupName", newJString(resourceGroupName))
  add(query_596951, "api-version", newJString(apiVersion))
  add(path_596949, "subscriptionId", newJString(subscriptionId))
  add(query_596951, "$top", newJInt(Top))
  add(query_596951, "$skip", newJInt(Skip))
  add(query_596951, "$inlinecount", newJString(Inlinecount))
  add(query_596951, "$filter", newJString(Filter))
  result = call_596948.call(path_596949, query_596951, nil, nil, nil)

var dscNodeConfigurationListByAutomationAccount* = Call_DscNodeConfigurationListByAutomationAccount_596680(
    name: "dscNodeConfigurationListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations",
    validator: validate_DscNodeConfigurationListByAutomationAccount_596681,
    base: "", url: url_DscNodeConfigurationListByAutomationAccount_596682,
    schemes: {Scheme.Https})
type
  Call_DscNodeConfigurationCreateOrUpdate_597002 = ref object of OpenApiRestCall_596458
proc url_DscNodeConfigurationCreateOrUpdate_597004(protocol: Scheme; host: string;
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
  assert "nodeConfigurationName" in path,
        "`nodeConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodeConfigurations/"),
               (kind: VariableSegment, value: "nodeConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeConfigurationCreateOrUpdate_597003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the node configuration identified by node configuration name.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeConfigurationName: JString (required)
  ##                        : The Dsc node configuration name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597031 = path.getOrDefault("automationAccountName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "automationAccountName", valid_597031
  var valid_597032 = path.getOrDefault("resourceGroupName")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "resourceGroupName", valid_597032
  var valid_597033 = path.getOrDefault("subscriptionId")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "subscriptionId", valid_597033
  var valid_597034 = path.getOrDefault("nodeConfigurationName")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "nodeConfigurationName", valid_597034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597035 = query.getOrDefault("api-version")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "api-version", valid_597035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The create or update parameters for configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597037: Call_DscNodeConfigurationCreateOrUpdate_597002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create the node configuration identified by node configuration name.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_DscNodeConfigurationCreateOrUpdate_597002;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; nodeConfigurationName: string;
          parameters: JsonNode): Recallable =
  ## dscNodeConfigurationCreateOrUpdate
  ## Create the node configuration identified by node configuration name.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeConfigurationName: string (required)
  ##                        : The Dsc node configuration name.
  ##   parameters: JObject (required)
  ##             : The create or update parameters for configuration.
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  var body_597041 = newJObject()
  add(path_597039, "automationAccountName", newJString(automationAccountName))
  add(path_597039, "resourceGroupName", newJString(resourceGroupName))
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "subscriptionId", newJString(subscriptionId))
  add(path_597039, "nodeConfigurationName", newJString(nodeConfigurationName))
  if parameters != nil:
    body_597041 = parameters
  result = call_597038.call(path_597039, query_597040, nil, nil, body_597041)

var dscNodeConfigurationCreateOrUpdate* = Call_DscNodeConfigurationCreateOrUpdate_597002(
    name: "dscNodeConfigurationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations/{nodeConfigurationName}",
    validator: validate_DscNodeConfigurationCreateOrUpdate_597003, base: "",
    url: url_DscNodeConfigurationCreateOrUpdate_597004, schemes: {Scheme.Https})
type
  Call_DscNodeConfigurationGet_596990 = ref object of OpenApiRestCall_596458
proc url_DscNodeConfigurationGet_596992(protocol: Scheme; host: string; base: string;
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
  assert "nodeConfigurationName" in path,
        "`nodeConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodeConfigurations/"),
               (kind: VariableSegment, value: "nodeConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeConfigurationGet_596991(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeConfigurationName: JString (required)
  ##                        : The Dsc node configuration name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596993 = path.getOrDefault("automationAccountName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "automationAccountName", valid_596993
  var valid_596994 = path.getOrDefault("resourceGroupName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "resourceGroupName", valid_596994
  var valid_596995 = path.getOrDefault("subscriptionId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "subscriptionId", valid_596995
  var valid_596996 = path.getOrDefault("nodeConfigurationName")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "nodeConfigurationName", valid_596996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596997 = query.getOrDefault("api-version")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "api-version", valid_596997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596998: Call_DscNodeConfigurationGet_596990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_596998.validator(path, query, header, formData, body)
  let scheme = call_596998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596998.url(scheme.get, call_596998.host, call_596998.base,
                         call_596998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596998, url, valid)

proc call*(call_596999: Call_DscNodeConfigurationGet_596990;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; nodeConfigurationName: string): Recallable =
  ## dscNodeConfigurationGet
  ## Retrieve the Dsc node configurations by node configuration.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeConfigurationName: string (required)
  ##                        : The Dsc node configuration name.
  var path_597000 = newJObject()
  var query_597001 = newJObject()
  add(path_597000, "automationAccountName", newJString(automationAccountName))
  add(path_597000, "resourceGroupName", newJString(resourceGroupName))
  add(query_597001, "api-version", newJString(apiVersion))
  add(path_597000, "subscriptionId", newJString(subscriptionId))
  add(path_597000, "nodeConfigurationName", newJString(nodeConfigurationName))
  result = call_596999.call(path_597000, query_597001, nil, nil, nil)

var dscNodeConfigurationGet* = Call_DscNodeConfigurationGet_596990(
    name: "dscNodeConfigurationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations/{nodeConfigurationName}",
    validator: validate_DscNodeConfigurationGet_596991, base: "",
    url: url_DscNodeConfigurationGet_596992, schemes: {Scheme.Https})
type
  Call_DscNodeConfigurationDelete_597042 = ref object of OpenApiRestCall_596458
proc url_DscNodeConfigurationDelete_597044(protocol: Scheme; host: string;
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
  assert "nodeConfigurationName" in path,
        "`nodeConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodeConfigurations/"),
               (kind: VariableSegment, value: "nodeConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeConfigurationDelete_597043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeConfigurationName: JString (required)
  ##                        : The Dsc node configuration name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597045 = path.getOrDefault("automationAccountName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "automationAccountName", valid_597045
  var valid_597046 = path.getOrDefault("resourceGroupName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceGroupName", valid_597046
  var valid_597047 = path.getOrDefault("subscriptionId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "subscriptionId", valid_597047
  var valid_597048 = path.getOrDefault("nodeConfigurationName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "nodeConfigurationName", valid_597048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597049 = query.getOrDefault("api-version")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "api-version", valid_597049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597050: Call_DscNodeConfigurationDelete_597042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_597050.validator(path, query, header, formData, body)
  let scheme = call_597050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597050.url(scheme.get, call_597050.host, call_597050.base,
                         call_597050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597050, url, valid)

proc call*(call_597051: Call_DscNodeConfigurationDelete_597042;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; nodeConfigurationName: string): Recallable =
  ## dscNodeConfigurationDelete
  ## Delete the Dsc node configurations by node configuration.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeConfigurationName: string (required)
  ##                        : The Dsc node configuration name.
  var path_597052 = newJObject()
  var query_597053 = newJObject()
  add(path_597052, "automationAccountName", newJString(automationAccountName))
  add(path_597052, "resourceGroupName", newJString(resourceGroupName))
  add(query_597053, "api-version", newJString(apiVersion))
  add(path_597052, "subscriptionId", newJString(subscriptionId))
  add(path_597052, "nodeConfigurationName", newJString(nodeConfigurationName))
  result = call_597051.call(path_597052, query_597053, nil, nil, nil)

var dscNodeConfigurationDelete* = Call_DscNodeConfigurationDelete_597042(
    name: "dscNodeConfigurationDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations/{nodeConfigurationName}",
    validator: validate_DscNodeConfigurationDelete_597043, base: "",
    url: url_DscNodeConfigurationDelete_597044, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
