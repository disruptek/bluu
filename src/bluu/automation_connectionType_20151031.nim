
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "automation-connectionType"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConnectionTypeListByAutomationAccount_563777 = ref object of OpenApiRestCall_563555
proc url_ConnectionTypeListByAutomationAccount_563779(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/connectionTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionTypeListByAutomationAccount_563778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of connection types.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
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
  var valid_563941 = path.getOrDefault("automationAccountName")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "automationAccountName", valid_563941
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  var valid_563943 = path.getOrDefault("resourceGroupName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "resourceGroupName", valid_563943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563944 = query.getOrDefault("api-version")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "api-version", valid_563944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563971: Call_ConnectionTypeListByAutomationAccount_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of connection types.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_563971.validator(path, query, header, formData, body)
  let scheme = call_563971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563971.url(scheme.get, call_563971.host, call_563971.base,
                         call_563971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563971, url, valid)

proc call*(call_564042: Call_ConnectionTypeListByAutomationAccount_563777;
          apiVersion: string; automationAccountName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## connectionTypeListByAutomationAccount
  ## Retrieve a list of connection types.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564043 = newJObject()
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  add(path_564043, "automationAccountName", newJString(automationAccountName))
  add(path_564043, "subscriptionId", newJString(subscriptionId))
  add(path_564043, "resourceGroupName", newJString(resourceGroupName))
  result = call_564042.call(path_564043, query_564045, nil, nil, nil)

var connectionTypeListByAutomationAccount* = Call_ConnectionTypeListByAutomationAccount_563777(
    name: "connectionTypeListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes",
    validator: validate_ConnectionTypeListByAutomationAccount_563778, base: "",
    url: url_ConnectionTypeListByAutomationAccount_563779, schemes: {Scheme.Https})
type
  Call_ConnectionTypeCreateOrUpdate_564096 = ref object of OpenApiRestCall_563555
proc url_ConnectionTypeCreateOrUpdate_564098(protocol: Scheme; host: string;
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
  assert "connectionTypeName" in path,
        "`connectionTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/connectionTypes/"),
               (kind: VariableSegment, value: "connectionTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionTypeCreateOrUpdate_564097(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: JString (required)
  ##                     : The parameters supplied to the create or update connection type operation.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564125 = path.getOrDefault("automationAccountName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "automationAccountName", valid_564125
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("connectionTypeName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "connectionTypeName", valid_564127
  var valid_564128 = path.getOrDefault("resourceGroupName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceGroupName", valid_564128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "api-version", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create or update connection type operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ConnectionTypeCreateOrUpdate_564096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ConnectionTypeCreateOrUpdate_564096;
          apiVersion: string; automationAccountName: string; subscriptionId: string;
          connectionTypeName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## connectionTypeCreateOrUpdate
  ## Create a connection type.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: string (required)
  ##                     : The parameters supplied to the create or update connection type operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create or update connection type operation.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  var body_564135 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "automationAccountName", newJString(automationAccountName))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(path_564133, "connectionTypeName", newJString(connectionTypeName))
  add(path_564133, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564135 = parameters
  result = call_564132.call(path_564133, query_564134, nil, nil, body_564135)

var connectionTypeCreateOrUpdate* = Call_ConnectionTypeCreateOrUpdate_564096(
    name: "connectionTypeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes/{connectionTypeName}",
    validator: validate_ConnectionTypeCreateOrUpdate_564097, base: "",
    url: url_ConnectionTypeCreateOrUpdate_564098, schemes: {Scheme.Https})
type
  Call_ConnectionTypeGet_564084 = ref object of OpenApiRestCall_563555
proc url_ConnectionTypeGet_564086(protocol: Scheme; host: string; base: string;
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
  assert "connectionTypeName" in path,
        "`connectionTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/connectionTypes/"),
               (kind: VariableSegment, value: "connectionTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionTypeGet_564085(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieve the connection type identified by connection type name.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: JString (required)
  ##                     : The name of connection type.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564087 = path.getOrDefault("automationAccountName")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "automationAccountName", valid_564087
  var valid_564088 = path.getOrDefault("subscriptionId")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "subscriptionId", valid_564088
  var valid_564089 = path.getOrDefault("connectionTypeName")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "connectionTypeName", valid_564089
  var valid_564090 = path.getOrDefault("resourceGroupName")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "resourceGroupName", valid_564090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564091 = query.getOrDefault("api-version")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "api-version", valid_564091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564092: Call_ConnectionTypeGet_564084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the connection type identified by connection type name.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_564092.validator(path, query, header, formData, body)
  let scheme = call_564092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564092.url(scheme.get, call_564092.host, call_564092.base,
                         call_564092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564092, url, valid)

proc call*(call_564093: Call_ConnectionTypeGet_564084; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          connectionTypeName: string; resourceGroupName: string): Recallable =
  ## connectionTypeGet
  ## Retrieve the connection type identified by connection type name.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: string (required)
  ##                     : The name of connection type.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564094 = newJObject()
  var query_564095 = newJObject()
  add(query_564095, "api-version", newJString(apiVersion))
  add(path_564094, "automationAccountName", newJString(automationAccountName))
  add(path_564094, "subscriptionId", newJString(subscriptionId))
  add(path_564094, "connectionTypeName", newJString(connectionTypeName))
  add(path_564094, "resourceGroupName", newJString(resourceGroupName))
  result = call_564093.call(path_564094, query_564095, nil, nil, nil)

var connectionTypeGet* = Call_ConnectionTypeGet_564084(name: "connectionTypeGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes/{connectionTypeName}",
    validator: validate_ConnectionTypeGet_564085, base: "",
    url: url_ConnectionTypeGet_564086, schemes: {Scheme.Https})
type
  Call_ConnectionTypeDelete_564136 = ref object of OpenApiRestCall_563555
proc url_ConnectionTypeDelete_564138(protocol: Scheme; host: string; base: string;
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
  assert "connectionTypeName" in path,
        "`connectionTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/connectionTypes/"),
               (kind: VariableSegment, value: "connectionTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionTypeDelete_564137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: JString (required)
  ##                     : The name of connection type.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564139 = path.getOrDefault("automationAccountName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "automationAccountName", valid_564139
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("connectionTypeName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "connectionTypeName", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_ConnectionTypeDelete_564136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_ConnectionTypeDelete_564136; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          connectionTypeName: string; resourceGroupName: string): Recallable =
  ## connectionTypeDelete
  ## Delete the connection type.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: string (required)
  ##                     : The name of connection type.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "automationAccountName", newJString(automationAccountName))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "connectionTypeName", newJString(connectionTypeName))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var connectionTypeDelete* = Call_ConnectionTypeDelete_564136(
    name: "connectionTypeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes/{connectionTypeName}",
    validator: validate_ConnectionTypeDelete_564137, base: "",
    url: url_ConnectionTypeDelete_564138, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
