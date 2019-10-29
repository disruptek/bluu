
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "automation-dscNodeConfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DscNodeConfigurationListByAutomationAccount_563778 = ref object of OpenApiRestCall_563556
proc url_DscNodeConfigurationListByAutomationAccount_563780(protocol: Scheme;
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

proc validate_DscNodeConfigurationListByAutomationAccount_563779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of dsc node configurations.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_563943 = path.getOrDefault("automationAccountName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "automationAccountName", valid_563943
  var valid_563944 = path.getOrDefault("subscriptionId")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "subscriptionId", valid_563944
  var valid_563945 = path.getOrDefault("resourceGroupName")
  valid_563945 = validateParameter(valid_563945, JString, required = true,
                                 default = nil)
  if valid_563945 != nil:
    section.add "resourceGroupName", valid_563945
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of rows to take.
  ##   $skip: JInt
  ##        : The number of rows to skip.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $inlinecount: JString
  ##               : Return total rows.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563946 = query.getOrDefault("api-version")
  valid_563946 = validateParameter(valid_563946, JString, required = true,
                                 default = nil)
  if valid_563946 != nil:
    section.add "api-version", valid_563946
  var valid_563947 = query.getOrDefault("$top")
  valid_563947 = validateParameter(valid_563947, JInt, required = false, default = nil)
  if valid_563947 != nil:
    section.add "$top", valid_563947
  var valid_563948 = query.getOrDefault("$skip")
  valid_563948 = validateParameter(valid_563948, JInt, required = false, default = nil)
  if valid_563948 != nil:
    section.add "$skip", valid_563948
  var valid_563949 = query.getOrDefault("$filter")
  valid_563949 = validateParameter(valid_563949, JString, required = false,
                                 default = nil)
  if valid_563949 != nil:
    section.add "$filter", valid_563949
  var valid_563950 = query.getOrDefault("$inlinecount")
  valid_563950 = validateParameter(valid_563950, JString, required = false,
                                 default = nil)
  if valid_563950 != nil:
    section.add "$inlinecount", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563977: Call_DscNodeConfigurationListByAutomationAccount_563778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of dsc node configurations.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_563977.validator(path, query, header, formData, body)
  let scheme = call_563977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563977.url(scheme.get, call_563977.host, call_563977.base,
                         call_563977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563977, url, valid)

proc call*(call_564048: Call_DscNodeConfigurationListByAutomationAccount_563778;
          apiVersion: string; automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Skip: int = 0; Filter: string = "";
          Inlinecount: string = ""): Recallable =
  ## dscNodeConfigurationListByAutomationAccount
  ## Retrieve a list of dsc node configurations.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   Top: int
  ##      : The number of rows to take.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : The number of rows to skip.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   Inlinecount: string
  ##              : Return total rows.
  var path_564049 = newJObject()
  var query_564051 = newJObject()
  add(query_564051, "api-version", newJString(apiVersion))
  add(path_564049, "automationAccountName", newJString(automationAccountName))
  add(query_564051, "$top", newJInt(Top))
  add(path_564049, "subscriptionId", newJString(subscriptionId))
  add(query_564051, "$skip", newJInt(Skip))
  add(path_564049, "resourceGroupName", newJString(resourceGroupName))
  add(query_564051, "$filter", newJString(Filter))
  add(query_564051, "$inlinecount", newJString(Inlinecount))
  result = call_564048.call(path_564049, query_564051, nil, nil, nil)

var dscNodeConfigurationListByAutomationAccount* = Call_DscNodeConfigurationListByAutomationAccount_563778(
    name: "dscNodeConfigurationListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations",
    validator: validate_DscNodeConfigurationListByAutomationAccount_563779,
    base: "", url: url_DscNodeConfigurationListByAutomationAccount_563780,
    schemes: {Scheme.Https})
type
  Call_DscNodeConfigurationCreateOrUpdate_564102 = ref object of OpenApiRestCall_563556
proc url_DscNodeConfigurationCreateOrUpdate_564104(protocol: Scheme; host: string;
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

proc validate_DscNodeConfigurationCreateOrUpdate_564103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the node configuration identified by node configuration name.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   nodeConfigurationName: JString (required)
  ##                        : The Dsc node configuration name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564131 = path.getOrDefault("automationAccountName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "automationAccountName", valid_564131
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  var valid_564134 = path.getOrDefault("nodeConfigurationName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "nodeConfigurationName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
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

proc call*(call_564137: Call_DscNodeConfigurationCreateOrUpdate_564102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create the node configuration identified by node configuration name.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_DscNodeConfigurationCreateOrUpdate_564102;
          apiVersion: string; automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; nodeConfigurationName: string;
          parameters: JsonNode): Recallable =
  ## dscNodeConfigurationCreateOrUpdate
  ## Create the node configuration identified by node configuration name.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   nodeConfigurationName: string (required)
  ##                        : The Dsc node configuration name.
  ##   parameters: JObject (required)
  ##             : The create or update parameters for configuration.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "automationAccountName", newJString(automationAccountName))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  add(path_564139, "nodeConfigurationName", newJString(nodeConfigurationName))
  if parameters != nil:
    body_564141 = parameters
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var dscNodeConfigurationCreateOrUpdate* = Call_DscNodeConfigurationCreateOrUpdate_564102(
    name: "dscNodeConfigurationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations/{nodeConfigurationName}",
    validator: validate_DscNodeConfigurationCreateOrUpdate_564103, base: "",
    url: url_DscNodeConfigurationCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_DscNodeConfigurationGet_564090 = ref object of OpenApiRestCall_563556
proc url_DscNodeConfigurationGet_564092(protocol: Scheme; host: string; base: string;
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

proc validate_DscNodeConfigurationGet_564091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   nodeConfigurationName: JString (required)
  ##                        : The Dsc node configuration name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564093 = path.getOrDefault("automationAccountName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "automationAccountName", valid_564093
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  var valid_564096 = path.getOrDefault("nodeConfigurationName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "nodeConfigurationName", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_DscNodeConfigurationGet_564090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_DscNodeConfigurationGet_564090; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; nodeConfigurationName: string): Recallable =
  ## dscNodeConfigurationGet
  ## Retrieve the Dsc node configurations by node configuration.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   nodeConfigurationName: string (required)
  ##                        : The Dsc node configuration name.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "automationAccountName", newJString(automationAccountName))
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  add(path_564100, "resourceGroupName", newJString(resourceGroupName))
  add(path_564100, "nodeConfigurationName", newJString(nodeConfigurationName))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var dscNodeConfigurationGet* = Call_DscNodeConfigurationGet_564090(
    name: "dscNodeConfigurationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations/{nodeConfigurationName}",
    validator: validate_DscNodeConfigurationGet_564091, base: "",
    url: url_DscNodeConfigurationGet_564092, schemes: {Scheme.Https})
type
  Call_DscNodeConfigurationDelete_564142 = ref object of OpenApiRestCall_563556
proc url_DscNodeConfigurationDelete_564144(protocol: Scheme; host: string;
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

proc validate_DscNodeConfigurationDelete_564143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   nodeConfigurationName: JString (required)
  ##                        : The Dsc node configuration name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564145 = path.getOrDefault("automationAccountName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "automationAccountName", valid_564145
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  var valid_564148 = path.getOrDefault("nodeConfigurationName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "nodeConfigurationName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_DscNodeConfigurationDelete_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the Dsc node configurations by node configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_DscNodeConfigurationDelete_564142; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; nodeConfigurationName: string): Recallable =
  ## dscNodeConfigurationDelete
  ## Delete the Dsc node configurations by node configuration.
  ## http://aka.ms/azureautomationsdk/dscnodeconfigurations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   nodeConfigurationName: string (required)
  ##                        : The Dsc node configuration name.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "automationAccountName", newJString(automationAccountName))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(path_564152, "resourceGroupName", newJString(resourceGroupName))
  add(path_564152, "nodeConfigurationName", newJString(nodeConfigurationName))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var dscNodeConfigurationDelete* = Call_DscNodeConfigurationDelete_564142(
    name: "dscNodeConfigurationDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodeConfigurations/{nodeConfigurationName}",
    validator: validate_DscNodeConfigurationDelete_564143, base: "",
    url: url_DscNodeConfigurationDelete_564144, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
