
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

  OpenApiRestCall_596459 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596459](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596459): Option[Scheme] {.used.} =
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
  macServiceName = "automation-dscNode"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AgentRegistrationInformationGet_596681 = ref object of OpenApiRestCall_596459
proc url_AgentRegistrationInformationGet_596683(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/agentRegistrationInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentRegistrationInformationGet_596682(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the automation agent registration information.
  ## 
  ## http://aka.ms/azureautomationsdk/agentregistrationoperations
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596846 = query.getOrDefault("api-version")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "api-version", valid_596846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596873: Call_AgentRegistrationInformationGet_596681;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the automation agent registration information.
  ## 
  ## http://aka.ms/azureautomationsdk/agentregistrationoperations
  let valid = call_596873.validator(path, query, header, formData, body)
  let scheme = call_596873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596873.url(scheme.get, call_596873.host, call_596873.base,
                         call_596873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596873, url, valid)

proc call*(call_596944: Call_AgentRegistrationInformationGet_596681;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## agentRegistrationInformationGet
  ## Retrieve the automation agent registration information.
  ## http://aka.ms/azureautomationsdk/agentregistrationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596945 = newJObject()
  var query_596947 = newJObject()
  add(path_596945, "automationAccountName", newJString(automationAccountName))
  add(path_596945, "resourceGroupName", newJString(resourceGroupName))
  add(query_596947, "api-version", newJString(apiVersion))
  add(path_596945, "subscriptionId", newJString(subscriptionId))
  result = call_596944.call(path_596945, query_596947, nil, nil, nil)

var agentRegistrationInformationGet* = Call_AgentRegistrationInformationGet_596681(
    name: "agentRegistrationInformationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/agentRegistrationInformation",
    validator: validate_AgentRegistrationInformationGet_596682, base: "",
    url: url_AgentRegistrationInformationGet_596683, schemes: {Scheme.Https})
type
  Call_AgentRegistrationInformationRegenerateKey_596986 = ref object of OpenApiRestCall_596459
proc url_AgentRegistrationInformationRegenerateKey_596988(protocol: Scheme;
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
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment,
        value: "/agentRegistrationInformation/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgentRegistrationInformationRegenerateKey_596987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate a primary or secondary agent registration key
  ## 
  ## http://aka.ms/azureautomationsdk/agentregistrationoperations
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
  var valid_597015 = path.getOrDefault("automationAccountName")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "automationAccountName", valid_597015
  var valid_597016 = path.getOrDefault("resourceGroupName")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "resourceGroupName", valid_597016
  var valid_597017 = path.getOrDefault("subscriptionId")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "subscriptionId", valid_597017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597018 = query.getOrDefault("api-version")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "api-version", valid_597018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The name of the agent registration key to be regenerated
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597020: Call_AgentRegistrationInformationRegenerateKey_596986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate a primary or secondary agent registration key
  ## 
  ## http://aka.ms/azureautomationsdk/agentregistrationoperations
  let valid = call_597020.validator(path, query, header, formData, body)
  let scheme = call_597020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597020.url(scheme.get, call_597020.host, call_597020.base,
                         call_597020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597020, url, valid)

proc call*(call_597021: Call_AgentRegistrationInformationRegenerateKey_596986;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## agentRegistrationInformationRegenerateKey
  ## Regenerate a primary or secondary agent registration key
  ## http://aka.ms/azureautomationsdk/agentregistrationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The name of the agent registration key to be regenerated
  var path_597022 = newJObject()
  var query_597023 = newJObject()
  var body_597024 = newJObject()
  add(path_597022, "automationAccountName", newJString(automationAccountName))
  add(path_597022, "resourceGroupName", newJString(resourceGroupName))
  add(query_597023, "api-version", newJString(apiVersion))
  add(path_597022, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597024 = parameters
  result = call_597021.call(path_597022, query_597023, nil, nil, body_597024)

var agentRegistrationInformationRegenerateKey* = Call_AgentRegistrationInformationRegenerateKey_596986(
    name: "agentRegistrationInformationRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/agentRegistrationInformation/regenerateKey",
    validator: validate_AgentRegistrationInformationRegenerateKey_596987,
    base: "", url: url_AgentRegistrationInformationRegenerateKey_596988,
    schemes: {Scheme.Https})
type
  Call_DscNodeListByAutomationAccount_597025 = ref object of OpenApiRestCall_596459
proc url_DscNodeListByAutomationAccount_597027(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeListByAutomationAccount_597026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of dsc nodes.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
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
  var valid_597029 = path.getOrDefault("automationAccountName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "automationAccountName", valid_597029
  var valid_597030 = path.getOrDefault("resourceGroupName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "resourceGroupName", valid_597030
  var valid_597031 = path.getOrDefault("subscriptionId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "subscriptionId", valid_597031
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
  var valid_597032 = query.getOrDefault("api-version")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "api-version", valid_597032
  var valid_597033 = query.getOrDefault("$top")
  valid_597033 = validateParameter(valid_597033, JInt, required = false, default = nil)
  if valid_597033 != nil:
    section.add "$top", valid_597033
  var valid_597034 = query.getOrDefault("$skip")
  valid_597034 = validateParameter(valid_597034, JInt, required = false, default = nil)
  if valid_597034 != nil:
    section.add "$skip", valid_597034
  var valid_597035 = query.getOrDefault("$inlinecount")
  valid_597035 = validateParameter(valid_597035, JString, required = false,
                                 default = nil)
  if valid_597035 != nil:
    section.add "$inlinecount", valid_597035
  var valid_597036 = query.getOrDefault("$filter")
  valid_597036 = validateParameter(valid_597036, JString, required = false,
                                 default = nil)
  if valid_597036 != nil:
    section.add "$filter", valid_597036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597037: Call_DscNodeListByAutomationAccount_597025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of dsc nodes.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_DscNodeListByAutomationAccount_597025;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: int = 0; Skip: int = 0;
          Inlinecount: string = ""; Filter: string = ""): Recallable =
  ## dscNodeListByAutomationAccount
  ## Retrieve a list of dsc nodes.
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
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
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  add(path_597039, "automationAccountName", newJString(automationAccountName))
  add(path_597039, "resourceGroupName", newJString(resourceGroupName))
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "subscriptionId", newJString(subscriptionId))
  add(query_597040, "$top", newJInt(Top))
  add(query_597040, "$skip", newJInt(Skip))
  add(query_597040, "$inlinecount", newJString(Inlinecount))
  add(query_597040, "$filter", newJString(Filter))
  result = call_597038.call(path_597039, query_597040, nil, nil, nil)

var dscNodeListByAutomationAccount* = Call_DscNodeListByAutomationAccount_597025(
    name: "dscNodeListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes",
    validator: validate_DscNodeListByAutomationAccount_597026, base: "",
    url: url_DscNodeListByAutomationAccount_597027, schemes: {Scheme.Https})
type
  Call_DscNodeGet_597041 = ref object of OpenApiRestCall_596459
proc url_DscNodeGet_597043(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeGet_597042(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the dsc node identified by node id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: JString (required)
  ##         : The node id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597044 = path.getOrDefault("automationAccountName")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "automationAccountName", valid_597044
  var valid_597045 = path.getOrDefault("resourceGroupName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "resourceGroupName", valid_597045
  var valid_597046 = path.getOrDefault("subscriptionId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "subscriptionId", valid_597046
  var valid_597047 = path.getOrDefault("nodeId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "nodeId", valid_597047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597048 = query.getOrDefault("api-version")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "api-version", valid_597048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597049: Call_DscNodeGet_597041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the dsc node identified by node id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  let valid = call_597049.validator(path, query, header, formData, body)
  let scheme = call_597049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597049.url(scheme.get, call_597049.host, call_597049.base,
                         call_597049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597049, url, valid)

proc call*(call_597050: Call_DscNodeGet_597041; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          nodeId: string): Recallable =
  ## dscNodeGet
  ## Retrieve the dsc node identified by node id.
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: string (required)
  ##         : The node id.
  var path_597051 = newJObject()
  var query_597052 = newJObject()
  add(path_597051, "automationAccountName", newJString(automationAccountName))
  add(path_597051, "resourceGroupName", newJString(resourceGroupName))
  add(query_597052, "api-version", newJString(apiVersion))
  add(path_597051, "subscriptionId", newJString(subscriptionId))
  add(path_597051, "nodeId", newJString(nodeId))
  result = call_597050.call(path_597051, query_597052, nil, nil, nil)

var dscNodeGet* = Call_DscNodeGet_597041(name: "dscNodeGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes/{nodeId}",
                                      validator: validate_DscNodeGet_597042,
                                      base: "", url: url_DscNodeGet_597043,
                                      schemes: {Scheme.Https})
type
  Call_DscNodeUpdate_597065 = ref object of OpenApiRestCall_596459
proc url_DscNodeUpdate_597067(protocol: Scheme; host: string; base: string;
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
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeUpdate_597066(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the dsc node.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: JString (required)
  ##         : Parameters supplied to the update dsc node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597068 = path.getOrDefault("automationAccountName")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "automationAccountName", valid_597068
  var valid_597069 = path.getOrDefault("resourceGroupName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "resourceGroupName", valid_597069
  var valid_597070 = path.getOrDefault("subscriptionId")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "subscriptionId", valid_597070
  var valid_597071 = path.getOrDefault("nodeId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "nodeId", valid_597071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597072 = query.getOrDefault("api-version")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "api-version", valid_597072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dscNodeUpdateParameters: JObject (required)
  ##                          : Parameters supplied to the update dsc node.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597074: Call_DscNodeUpdate_597065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the dsc node.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  let valid = call_597074.validator(path, query, header, formData, body)
  let scheme = call_597074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597074.url(scheme.get, call_597074.host, call_597074.base,
                         call_597074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597074, url, valid)

proc call*(call_597075: Call_DscNodeUpdate_597065; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          nodeId: string; dscNodeUpdateParameters: JsonNode): Recallable =
  ## dscNodeUpdate
  ## Update the dsc node.
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: string (required)
  ##         : Parameters supplied to the update dsc node.
  ##   dscNodeUpdateParameters: JObject (required)
  ##                          : Parameters supplied to the update dsc node.
  var path_597076 = newJObject()
  var query_597077 = newJObject()
  var body_597078 = newJObject()
  add(path_597076, "automationAccountName", newJString(automationAccountName))
  add(path_597076, "resourceGroupName", newJString(resourceGroupName))
  add(query_597077, "api-version", newJString(apiVersion))
  add(path_597076, "subscriptionId", newJString(subscriptionId))
  add(path_597076, "nodeId", newJString(nodeId))
  if dscNodeUpdateParameters != nil:
    body_597078 = dscNodeUpdateParameters
  result = call_597075.call(path_597076, query_597077, nil, nil, body_597078)

var dscNodeUpdate* = Call_DscNodeUpdate_597065(name: "dscNodeUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes/{nodeId}",
    validator: validate_DscNodeUpdate_597066, base: "", url: url_DscNodeUpdate_597067,
    schemes: {Scheme.Https})
type
  Call_DscNodeDelete_597053 = ref object of OpenApiRestCall_596459
proc url_DscNodeDelete_597055(protocol: Scheme; host: string; base: string;
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
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscNodeDelete_597054(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the dsc node identified by node id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: JString (required)
  ##         : The node id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597056 = path.getOrDefault("automationAccountName")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "automationAccountName", valid_597056
  var valid_597057 = path.getOrDefault("resourceGroupName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceGroupName", valid_597057
  var valid_597058 = path.getOrDefault("subscriptionId")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "subscriptionId", valid_597058
  var valid_597059 = path.getOrDefault("nodeId")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "nodeId", valid_597059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597060 = query.getOrDefault("api-version")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "api-version", valid_597060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597061: Call_DscNodeDelete_597053; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the dsc node identified by node id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  let valid = call_597061.validator(path, query, header, formData, body)
  let scheme = call_597061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597061.url(scheme.get, call_597061.host, call_597061.base,
                         call_597061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597061, url, valid)

proc call*(call_597062: Call_DscNodeDelete_597053; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          nodeId: string): Recallable =
  ## dscNodeDelete
  ## Delete the dsc node identified by node id.
  ## http://aka.ms/azureautomationsdk/dscnodeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: string (required)
  ##         : The node id.
  var path_597063 = newJObject()
  var query_597064 = newJObject()
  add(path_597063, "automationAccountName", newJString(automationAccountName))
  add(path_597063, "resourceGroupName", newJString(resourceGroupName))
  add(query_597064, "api-version", newJString(apiVersion))
  add(path_597063, "subscriptionId", newJString(subscriptionId))
  add(path_597063, "nodeId", newJString(nodeId))
  result = call_597062.call(path_597063, query_597064, nil, nil, nil)

var dscNodeDelete* = Call_DscNodeDelete_597053(name: "dscNodeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes/{nodeId}",
    validator: validate_DscNodeDelete_597054, base: "", url: url_DscNodeDelete_597055,
    schemes: {Scheme.Https})
type
  Call_NodeReportsListByNode_597079 = ref object of OpenApiRestCall_596459
proc url_NodeReportsListByNode_597081(protocol: Scheme; host: string; base: string;
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
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeReportsListByNode_597080(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Dsc node report list by node id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: JString (required)
  ##         : The parameters supplied to the list operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597082 = path.getOrDefault("automationAccountName")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "automationAccountName", valid_597082
  var valid_597083 = path.getOrDefault("resourceGroupName")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "resourceGroupName", valid_597083
  var valid_597084 = path.getOrDefault("subscriptionId")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "subscriptionId", valid_597084
  var valid_597085 = path.getOrDefault("nodeId")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "nodeId", valid_597085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597086 = query.getOrDefault("api-version")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "api-version", valid_597086
  var valid_597087 = query.getOrDefault("$filter")
  valid_597087 = validateParameter(valid_597087, JString, required = false,
                                 default = nil)
  if valid_597087 != nil:
    section.add "$filter", valid_597087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597088: Call_NodeReportsListByNode_597079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Dsc node report list by node id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  let valid = call_597088.validator(path, query, header, formData, body)
  let scheme = call_597088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597088.url(scheme.get, call_597088.host, call_597088.base,
                         call_597088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597088, url, valid)

proc call*(call_597089: Call_NodeReportsListByNode_597079;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; nodeId: string;
          Filter: string = ""): Recallable =
  ## nodeReportsListByNode
  ## Retrieve the Dsc node report list by node id.
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: string (required)
  ##         : The parameters supplied to the list operation.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597090 = newJObject()
  var query_597091 = newJObject()
  add(path_597090, "automationAccountName", newJString(automationAccountName))
  add(path_597090, "resourceGroupName", newJString(resourceGroupName))
  add(query_597091, "api-version", newJString(apiVersion))
  add(path_597090, "subscriptionId", newJString(subscriptionId))
  add(path_597090, "nodeId", newJString(nodeId))
  add(query_597091, "$filter", newJString(Filter))
  result = call_597089.call(path_597090, query_597091, nil, nil, nil)

var nodeReportsListByNode* = Call_NodeReportsListByNode_597079(
    name: "nodeReportsListByNode", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes/{nodeId}/reports",
    validator: validate_NodeReportsListByNode_597080, base: "",
    url: url_NodeReportsListByNode_597081, schemes: {Scheme.Https})
type
  Call_NodeReportsGet_597092 = ref object of OpenApiRestCall_596459
proc url_NodeReportsGet_597094(protocol: Scheme; host: string; base: string;
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
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeReportsGet_597093(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieve the Dsc node report data by node id and report id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: JString (required)
  ##         : The Dsc node id.
  ##   reportId: JString (required)
  ##           : The report id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597095 = path.getOrDefault("automationAccountName")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "automationAccountName", valid_597095
  var valid_597096 = path.getOrDefault("resourceGroupName")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "resourceGroupName", valid_597096
  var valid_597097 = path.getOrDefault("subscriptionId")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "subscriptionId", valid_597097
  var valid_597098 = path.getOrDefault("nodeId")
  valid_597098 = validateParameter(valid_597098, JString, required = true,
                                 default = nil)
  if valid_597098 != nil:
    section.add "nodeId", valid_597098
  var valid_597099 = path.getOrDefault("reportId")
  valid_597099 = validateParameter(valid_597099, JString, required = true,
                                 default = nil)
  if valid_597099 != nil:
    section.add "reportId", valid_597099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597100 = query.getOrDefault("api-version")
  valid_597100 = validateParameter(valid_597100, JString, required = true,
                                 default = nil)
  if valid_597100 != nil:
    section.add "api-version", valid_597100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597101: Call_NodeReportsGet_597092; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Dsc node report data by node id and report id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  let valid = call_597101.validator(path, query, header, formData, body)
  let scheme = call_597101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597101.url(scheme.get, call_597101.host, call_597101.base,
                         call_597101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597101, url, valid)

proc call*(call_597102: Call_NodeReportsGet_597092; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          nodeId: string; reportId: string): Recallable =
  ## nodeReportsGet
  ## Retrieve the Dsc node report data by node id and report id.
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: string (required)
  ##         : The Dsc node id.
  ##   reportId: string (required)
  ##           : The report id.
  var path_597103 = newJObject()
  var query_597104 = newJObject()
  add(path_597103, "automationAccountName", newJString(automationAccountName))
  add(path_597103, "resourceGroupName", newJString(resourceGroupName))
  add(query_597104, "api-version", newJString(apiVersion))
  add(path_597103, "subscriptionId", newJString(subscriptionId))
  add(path_597103, "nodeId", newJString(nodeId))
  add(path_597103, "reportId", newJString(reportId))
  result = call_597102.call(path_597103, query_597104, nil, nil, nil)

var nodeReportsGet* = Call_NodeReportsGet_597092(name: "nodeReportsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes/{nodeId}/reports/{reportId}",
    validator: validate_NodeReportsGet_597093, base: "", url: url_NodeReportsGet_597094,
    schemes: {Scheme.Https})
type
  Call_NodeReportsGetContent_597105 = ref object of OpenApiRestCall_596459
proc url_NodeReportsGetContent_597107(protocol: Scheme; host: string; base: string;
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
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeReportsGetContent_597106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Dsc node reports by node id and report id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: JString (required)
  ##         : The Dsc node id.
  ##   reportId: JString (required)
  ##           : The report id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597108 = path.getOrDefault("automationAccountName")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "automationAccountName", valid_597108
  var valid_597109 = path.getOrDefault("resourceGroupName")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "resourceGroupName", valid_597109
  var valid_597110 = path.getOrDefault("subscriptionId")
  valid_597110 = validateParameter(valid_597110, JString, required = true,
                                 default = nil)
  if valid_597110 != nil:
    section.add "subscriptionId", valid_597110
  var valid_597111 = path.getOrDefault("nodeId")
  valid_597111 = validateParameter(valid_597111, JString, required = true,
                                 default = nil)
  if valid_597111 != nil:
    section.add "nodeId", valid_597111
  var valid_597112 = path.getOrDefault("reportId")
  valid_597112 = validateParameter(valid_597112, JString, required = true,
                                 default = nil)
  if valid_597112 != nil:
    section.add "reportId", valid_597112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597113 = query.getOrDefault("api-version")
  valid_597113 = validateParameter(valid_597113, JString, required = true,
                                 default = nil)
  if valid_597113 != nil:
    section.add "api-version", valid_597113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597114: Call_NodeReportsGetContent_597105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Dsc node reports by node id and report id.
  ## 
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  let valid = call_597114.validator(path, query, header, formData, body)
  let scheme = call_597114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597114.url(scheme.get, call_597114.host, call_597114.base,
                         call_597114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597114, url, valid)

proc call*(call_597115: Call_NodeReportsGetContent_597105;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; nodeId: string; reportId: string): Recallable =
  ## nodeReportsGetContent
  ## Retrieve the Dsc node reports by node id and report id.
  ## http://aka.ms/azureautomationsdk/dscnodereportoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeId: string (required)
  ##         : The Dsc node id.
  ##   reportId: string (required)
  ##           : The report id.
  var path_597116 = newJObject()
  var query_597117 = newJObject()
  add(path_597116, "automationAccountName", newJString(automationAccountName))
  add(path_597116, "resourceGroupName", newJString(resourceGroupName))
  add(query_597117, "api-version", newJString(apiVersion))
  add(path_597116, "subscriptionId", newJString(subscriptionId))
  add(path_597116, "nodeId", newJString(nodeId))
  add(path_597116, "reportId", newJString(reportId))
  result = call_597115.call(path_597116, query_597117, nil, nil, nil)

var nodeReportsGetContent* = Call_NodeReportsGetContent_597105(
    name: "nodeReportsGetContent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodes/{nodeId}/reports/{reportId}/content",
    validator: validate_NodeReportsGetContent_597106, base: "",
    url: url_NodeReportsGetContent_597107, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
