
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
  macServiceName = "automation-hybridRunbookWorkerGroup"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HybridRunbookWorkerGroupListByAutomationAccount_596679 = ref object of OpenApiRestCall_596457
proc url_HybridRunbookWorkerGroupListByAutomationAccount_596681(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/hybridRunbookWorkerGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridRunbookWorkerGroupListByAutomationAccount_596680(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieve a list of hybrid runbook worker groups.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
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
  var valid_596842 = path.getOrDefault("automationAccountName")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "automationAccountName", valid_596842
  var valid_596843 = path.getOrDefault("resourceGroupName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "resourceGroupName", valid_596843
  var valid_596844 = path.getOrDefault("subscriptionId")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "subscriptionId", valid_596844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  var valid_596846 = query.getOrDefault("$filter")
  valid_596846 = validateParameter(valid_596846, JString, required = false,
                                 default = nil)
  if valid_596846 != nil:
    section.add "$filter", valid_596846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596873: Call_HybridRunbookWorkerGroupListByAutomationAccount_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of hybrid runbook worker groups.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  let valid = call_596873.validator(path, query, header, formData, body)
  let scheme = call_596873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596873.url(scheme.get, call_596873.host, call_596873.base,
                         call_596873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596873, url, valid)

proc call*(call_596944: Call_HybridRunbookWorkerGroupListByAutomationAccount_596679;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## hybridRunbookWorkerGroupListByAutomationAccount
  ## Retrieve a list of hybrid runbook worker groups.
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
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
  var path_596945 = newJObject()
  var query_596947 = newJObject()
  add(path_596945, "automationAccountName", newJString(automationAccountName))
  add(path_596945, "resourceGroupName", newJString(resourceGroupName))
  add(query_596947, "api-version", newJString(apiVersion))
  add(path_596945, "subscriptionId", newJString(subscriptionId))
  add(query_596947, "$filter", newJString(Filter))
  result = call_596944.call(path_596945, query_596947, nil, nil, nil)

var hybridRunbookWorkerGroupListByAutomationAccount* = Call_HybridRunbookWorkerGroupListByAutomationAccount_596679(
    name: "hybridRunbookWorkerGroupListByAutomationAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/hybridRunbookWorkerGroups",
    validator: validate_HybridRunbookWorkerGroupListByAutomationAccount_596680,
    base: "", url: url_HybridRunbookWorkerGroupListByAutomationAccount_596681,
    schemes: {Scheme.Https})
type
  Call_HybridRunbookWorkerGroupGet_596986 = ref object of OpenApiRestCall_596457
proc url_HybridRunbookWorkerGroupGet_596988(protocol: Scheme; host: string;
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
  assert "hybridRunbookWorkerGroupName" in path,
        "`hybridRunbookWorkerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/hybridRunbookWorkerGroups/"),
               (kind: VariableSegment, value: "hybridRunbookWorkerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridRunbookWorkerGroupGet_596987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a hybrid runbook worker group.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridRunbookWorkerGroupName: JString (required)
  ##                               : The hybrid runbook worker group name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596989 = path.getOrDefault("automationAccountName")
  valid_596989 = validateParameter(valid_596989, JString, required = true,
                                 default = nil)
  if valid_596989 != nil:
    section.add "automationAccountName", valid_596989
  var valid_596990 = path.getOrDefault("resourceGroupName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "resourceGroupName", valid_596990
  var valid_596991 = path.getOrDefault("subscriptionId")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "subscriptionId", valid_596991
  var valid_596992 = path.getOrDefault("hybridRunbookWorkerGroupName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "hybridRunbookWorkerGroupName", valid_596992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596993 = query.getOrDefault("api-version")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "api-version", valid_596993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596994: Call_HybridRunbookWorkerGroupGet_596986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a hybrid runbook worker group.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  let valid = call_596994.validator(path, query, header, formData, body)
  let scheme = call_596994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596994.url(scheme.get, call_596994.host, call_596994.base,
                         call_596994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596994, url, valid)

proc call*(call_596995: Call_HybridRunbookWorkerGroupGet_596986;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          hybridRunbookWorkerGroupName: string): Recallable =
  ## hybridRunbookWorkerGroupGet
  ## Retrieve a hybrid runbook worker group.
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridRunbookWorkerGroupName: string (required)
  ##                               : The hybrid runbook worker group name
  var path_596996 = newJObject()
  var query_596997 = newJObject()
  add(path_596996, "automationAccountName", newJString(automationAccountName))
  add(path_596996, "resourceGroupName", newJString(resourceGroupName))
  add(query_596997, "api-version", newJString(apiVersion))
  add(path_596996, "subscriptionId", newJString(subscriptionId))
  add(path_596996, "hybridRunbookWorkerGroupName",
      newJString(hybridRunbookWorkerGroupName))
  result = call_596995.call(path_596996, query_596997, nil, nil, nil)

var hybridRunbookWorkerGroupGet* = Call_HybridRunbookWorkerGroupGet_596986(
    name: "hybridRunbookWorkerGroupGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/hybridRunbookWorkerGroups/{hybridRunbookWorkerGroupName}",
    validator: validate_HybridRunbookWorkerGroupGet_596987, base: "",
    url: url_HybridRunbookWorkerGroupGet_596988, schemes: {Scheme.Https})
type
  Call_HybridRunbookWorkerGroupUpdate_597010 = ref object of OpenApiRestCall_596457
proc url_HybridRunbookWorkerGroupUpdate_597012(protocol: Scheme; host: string;
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
  assert "hybridRunbookWorkerGroupName" in path,
        "`hybridRunbookWorkerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/hybridRunbookWorkerGroups/"),
               (kind: VariableSegment, value: "hybridRunbookWorkerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridRunbookWorkerGroupUpdate_597011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a hybrid runbook worker group.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridRunbookWorkerGroupName: JString (required)
  ##                               : The hybrid runbook worker group name
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
  var valid_597042 = path.getOrDefault("hybridRunbookWorkerGroupName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "hybridRunbookWorkerGroupName", valid_597042
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
  ##             : The hybrid runbook worker group
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_HybridRunbookWorkerGroupUpdate_597010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a hybrid runbook worker group.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_HybridRunbookWorkerGroupUpdate_597010;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          hybridRunbookWorkerGroupName: string; parameters: JsonNode): Recallable =
  ## hybridRunbookWorkerGroupUpdate
  ## Update a hybrid runbook worker group.
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridRunbookWorkerGroupName: string (required)
  ##                               : The hybrid runbook worker group name
  ##   parameters: JObject (required)
  ##             : The hybrid runbook worker group
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  var body_597049 = newJObject()
  add(path_597047, "automationAccountName", newJString(automationAccountName))
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  add(path_597047, "hybridRunbookWorkerGroupName",
      newJString(hybridRunbookWorkerGroupName))
  if parameters != nil:
    body_597049 = parameters
  result = call_597046.call(path_597047, query_597048, nil, nil, body_597049)

var hybridRunbookWorkerGroupUpdate* = Call_HybridRunbookWorkerGroupUpdate_597010(
    name: "hybridRunbookWorkerGroupUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/hybridRunbookWorkerGroups/{hybridRunbookWorkerGroupName}",
    validator: validate_HybridRunbookWorkerGroupUpdate_597011, base: "",
    url: url_HybridRunbookWorkerGroupUpdate_597012, schemes: {Scheme.Https})
type
  Call_HybridRunbookWorkerGroupDelete_596998 = ref object of OpenApiRestCall_596457
proc url_HybridRunbookWorkerGroupDelete_597000(protocol: Scheme; host: string;
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
  assert "hybridRunbookWorkerGroupName" in path,
        "`hybridRunbookWorkerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/hybridRunbookWorkerGroups/"),
               (kind: VariableSegment, value: "hybridRunbookWorkerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HybridRunbookWorkerGroupDelete_596999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a hybrid runbook worker group.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridRunbookWorkerGroupName: JString (required)
  ##                               : The hybrid runbook worker group name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597001 = path.getOrDefault("automationAccountName")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "automationAccountName", valid_597001
  var valid_597002 = path.getOrDefault("resourceGroupName")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "resourceGroupName", valid_597002
  var valid_597003 = path.getOrDefault("subscriptionId")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "subscriptionId", valid_597003
  var valid_597004 = path.getOrDefault("hybridRunbookWorkerGroupName")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "hybridRunbookWorkerGroupName", valid_597004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597005 = query.getOrDefault("api-version")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "api-version", valid_597005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597006: Call_HybridRunbookWorkerGroupDelete_596998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a hybrid runbook worker group.
  ## 
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  let valid = call_597006.validator(path, query, header, formData, body)
  let scheme = call_597006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597006.url(scheme.get, call_597006.host, call_597006.base,
                         call_597006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597006, url, valid)

proc call*(call_597007: Call_HybridRunbookWorkerGroupDelete_596998;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          hybridRunbookWorkerGroupName: string): Recallable =
  ## hybridRunbookWorkerGroupDelete
  ## Delete a hybrid runbook worker group.
  ## http://aka.ms/azureautomationsdk/hybridrunbookworkergroupoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hybridRunbookWorkerGroupName: string (required)
  ##                               : The hybrid runbook worker group name
  var path_597008 = newJObject()
  var query_597009 = newJObject()
  add(path_597008, "automationAccountName", newJString(automationAccountName))
  add(path_597008, "resourceGroupName", newJString(resourceGroupName))
  add(query_597009, "api-version", newJString(apiVersion))
  add(path_597008, "subscriptionId", newJString(subscriptionId))
  add(path_597008, "hybridRunbookWorkerGroupName",
      newJString(hybridRunbookWorkerGroupName))
  result = call_597007.call(path_597008, query_597009, nil, nil, nil)

var hybridRunbookWorkerGroupDelete* = Call_HybridRunbookWorkerGroupDelete_596998(
    name: "hybridRunbookWorkerGroupDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/hybridRunbookWorkerGroups/{hybridRunbookWorkerGroupName}",
    validator: validate_HybridRunbookWorkerGroupDelete_596999, base: "",
    url: url_HybridRunbookWorkerGroupDelete_597000, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
