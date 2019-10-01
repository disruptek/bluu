
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "automation-connectionType"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConnectionTypeListByAutomationAccount_596679 = ref object of OpenApiRestCall_596457
proc url_ConnectionTypeListByAutomationAccount_596681(protocol: Scheme;
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

proc validate_ConnectionTypeListByAutomationAccount_596680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of connection types.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
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
  var valid_596841 = path.getOrDefault("automationAccountName")
  valid_596841 = validateParameter(valid_596841, JString, required = true,
                                 default = nil)
  if valid_596841 != nil:
    section.add "automationAccountName", valid_596841
  var valid_596842 = path.getOrDefault("resourceGroupName")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "resourceGroupName", valid_596842
  var valid_596843 = path.getOrDefault("subscriptionId")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "subscriptionId", valid_596843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596844 = query.getOrDefault("api-version")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "api-version", valid_596844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596871: Call_ConnectionTypeListByAutomationAccount_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of connection types.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_596871.validator(path, query, header, formData, body)
  let scheme = call_596871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596871.url(scheme.get, call_596871.host, call_596871.base,
                         call_596871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596871, url, valid)

proc call*(call_596942: Call_ConnectionTypeListByAutomationAccount_596679;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## connectionTypeListByAutomationAccount
  ## Retrieve a list of connection types.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596943 = newJObject()
  var query_596945 = newJObject()
  add(path_596943, "automationAccountName", newJString(automationAccountName))
  add(path_596943, "resourceGroupName", newJString(resourceGroupName))
  add(query_596945, "api-version", newJString(apiVersion))
  add(path_596943, "subscriptionId", newJString(subscriptionId))
  result = call_596942.call(path_596943, query_596945, nil, nil, nil)

var connectionTypeListByAutomationAccount* = Call_ConnectionTypeListByAutomationAccount_596679(
    name: "connectionTypeListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes",
    validator: validate_ConnectionTypeListByAutomationAccount_596680, base: "",
    url: url_ConnectionTypeListByAutomationAccount_596681, schemes: {Scheme.Https})
type
  Call_ConnectionTypeCreateOrUpdate_596996 = ref object of OpenApiRestCall_596457
proc url_ConnectionTypeCreateOrUpdate_596998(protocol: Scheme; host: string;
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

proc validate_ConnectionTypeCreateOrUpdate_596997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: JString (required)
  ##                     : The parameters supplied to the create or update connection type operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597025 = path.getOrDefault("automationAccountName")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "automationAccountName", valid_597025
  var valid_597026 = path.getOrDefault("resourceGroupName")
  valid_597026 = validateParameter(valid_597026, JString, required = true,
                                 default = nil)
  if valid_597026 != nil:
    section.add "resourceGroupName", valid_597026
  var valid_597027 = path.getOrDefault("subscriptionId")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "subscriptionId", valid_597027
  var valid_597028 = path.getOrDefault("connectionTypeName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "connectionTypeName", valid_597028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597029 = query.getOrDefault("api-version")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "api-version", valid_597029
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

proc call*(call_597031: Call_ConnectionTypeCreateOrUpdate_596996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_597031.validator(path, query, header, formData, body)
  let scheme = call_597031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597031.url(scheme.get, call_597031.host, call_597031.base,
                         call_597031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597031, url, valid)

proc call*(call_597032: Call_ConnectionTypeCreateOrUpdate_596996;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          connectionTypeName: string): Recallable =
  ## connectionTypeCreateOrUpdate
  ## Create a connection type.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create or update connection type operation.
  ##   connectionTypeName: string (required)
  ##                     : The parameters supplied to the create or update connection type operation.
  var path_597033 = newJObject()
  var query_597034 = newJObject()
  var body_597035 = newJObject()
  add(path_597033, "automationAccountName", newJString(automationAccountName))
  add(path_597033, "resourceGroupName", newJString(resourceGroupName))
  add(query_597034, "api-version", newJString(apiVersion))
  add(path_597033, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597035 = parameters
  add(path_597033, "connectionTypeName", newJString(connectionTypeName))
  result = call_597032.call(path_597033, query_597034, nil, nil, body_597035)

var connectionTypeCreateOrUpdate* = Call_ConnectionTypeCreateOrUpdate_596996(
    name: "connectionTypeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes/{connectionTypeName}",
    validator: validate_ConnectionTypeCreateOrUpdate_596997, base: "",
    url: url_ConnectionTypeCreateOrUpdate_596998, schemes: {Scheme.Https})
type
  Call_ConnectionTypeGet_596984 = ref object of OpenApiRestCall_596457
proc url_ConnectionTypeGet_596986(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionTypeGet_596985(path: JsonNode; query: JsonNode;
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
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: JString (required)
  ##                     : The name of connection type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596987 = path.getOrDefault("automationAccountName")
  valid_596987 = validateParameter(valid_596987, JString, required = true,
                                 default = nil)
  if valid_596987 != nil:
    section.add "automationAccountName", valid_596987
  var valid_596988 = path.getOrDefault("resourceGroupName")
  valid_596988 = validateParameter(valid_596988, JString, required = true,
                                 default = nil)
  if valid_596988 != nil:
    section.add "resourceGroupName", valid_596988
  var valid_596989 = path.getOrDefault("subscriptionId")
  valid_596989 = validateParameter(valid_596989, JString, required = true,
                                 default = nil)
  if valid_596989 != nil:
    section.add "subscriptionId", valid_596989
  var valid_596990 = path.getOrDefault("connectionTypeName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "connectionTypeName", valid_596990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596991 = query.getOrDefault("api-version")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "api-version", valid_596991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596992: Call_ConnectionTypeGet_596984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the connection type identified by connection type name.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_596992.validator(path, query, header, formData, body)
  let scheme = call_596992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596992.url(scheme.get, call_596992.host, call_596992.base,
                         call_596992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596992, url, valid)

proc call*(call_596993: Call_ConnectionTypeGet_596984;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectionTypeName: string): Recallable =
  ## connectionTypeGet
  ## Retrieve the connection type identified by connection type name.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: string (required)
  ##                     : The name of connection type.
  var path_596994 = newJObject()
  var query_596995 = newJObject()
  add(path_596994, "automationAccountName", newJString(automationAccountName))
  add(path_596994, "resourceGroupName", newJString(resourceGroupName))
  add(query_596995, "api-version", newJString(apiVersion))
  add(path_596994, "subscriptionId", newJString(subscriptionId))
  add(path_596994, "connectionTypeName", newJString(connectionTypeName))
  result = call_596993.call(path_596994, query_596995, nil, nil, nil)

var connectionTypeGet* = Call_ConnectionTypeGet_596984(name: "connectionTypeGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes/{connectionTypeName}",
    validator: validate_ConnectionTypeGet_596985, base: "",
    url: url_ConnectionTypeGet_596986, schemes: {Scheme.Https})
type
  Call_ConnectionTypeDelete_597036 = ref object of OpenApiRestCall_596457
proc url_ConnectionTypeDelete_597038(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionTypeDelete_597037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: JString (required)
  ##                     : The name of connection type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597039 = path.getOrDefault("automationAccountName")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "automationAccountName", valid_597039
  var valid_597040 = path.getOrDefault("resourceGroupName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "resourceGroupName", valid_597040
  var valid_597041 = path.getOrDefault("subscriptionId")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "subscriptionId", valid_597041
  var valid_597042 = path.getOrDefault("connectionTypeName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "connectionTypeName", valid_597042
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
  if body != nil:
    result.add "body", body

proc call*(call_597044: Call_ConnectionTypeDelete_597036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the connection type.
  ## 
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  let valid = call_597044.validator(path, query, header, formData, body)
  let scheme = call_597044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597044.url(scheme.get, call_597044.host, call_597044.base,
                         call_597044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597044, url, valid)

proc call*(call_597045: Call_ConnectionTypeDelete_597036;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectionTypeName: string): Recallable =
  ## connectionTypeDelete
  ## Delete the connection type.
  ## http://aka.ms/azureautomationsdk/connectiontypeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionTypeName: string (required)
  ##                     : The name of connection type.
  var path_597046 = newJObject()
  var query_597047 = newJObject()
  add(path_597046, "automationAccountName", newJString(automationAccountName))
  add(path_597046, "resourceGroupName", newJString(resourceGroupName))
  add(query_597047, "api-version", newJString(apiVersion))
  add(path_597046, "subscriptionId", newJString(subscriptionId))
  add(path_597046, "connectionTypeName", newJString(connectionTypeName))
  result = call_597045.call(path_597046, query_597047, nil, nil, nil)

var connectionTypeDelete* = Call_ConnectionTypeDelete_597036(
    name: "connectionTypeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/connectionTypes/{connectionTypeName}",
    validator: validate_ConnectionTypeDelete_597037, base: "",
    url: url_ConnectionTypeDelete_597038, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
