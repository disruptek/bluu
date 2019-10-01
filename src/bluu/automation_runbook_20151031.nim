
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
  macServiceName = "automation-runbook"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunbookListByAutomationAccount_596680 = ref object of OpenApiRestCall_596458
proc url_RunbookListByAutomationAccount_596682(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/runbooks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookListByAutomationAccount_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of runbooks.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596872: Call_RunbookListByAutomationAccount_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of runbooks.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  let valid = call_596872.validator(path, query, header, formData, body)
  let scheme = call_596872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596872.url(scheme.get, call_596872.host, call_596872.base,
                         call_596872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596872, url, valid)

proc call*(call_596943: Call_RunbookListByAutomationAccount_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## runbookListByAutomationAccount
  ## Retrieve a list of runbooks.
  ## http://aka.ms/azureautomationsdk/runbookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596944 = newJObject()
  var query_596946 = newJObject()
  add(path_596944, "automationAccountName", newJString(automationAccountName))
  add(path_596944, "resourceGroupName", newJString(resourceGroupName))
  add(query_596946, "api-version", newJString(apiVersion))
  add(path_596944, "subscriptionId", newJString(subscriptionId))
  result = call_596943.call(path_596944, query_596946, nil, nil, nil)

var runbookListByAutomationAccount* = Call_RunbookListByAutomationAccount_596680(
    name: "runbookListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks",
    validator: validate_RunbookListByAutomationAccount_596681, base: "",
    url: url_RunbookListByAutomationAccount_596682, schemes: {Scheme.Https})
type
  Call_RunbookCreateOrUpdate_596997 = ref object of OpenApiRestCall_596458
proc url_RunbookCreateOrUpdate_596999(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookCreateOrUpdate_596998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597026 = path.getOrDefault("automationAccountName")
  valid_597026 = validateParameter(valid_597026, JString, required = true,
                                 default = nil)
  if valid_597026 != nil:
    section.add "automationAccountName", valid_597026
  var valid_597027 = path.getOrDefault("resourceGroupName")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "resourceGroupName", valid_597027
  var valid_597028 = path.getOrDefault("runbookName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "runbookName", valid_597028
  var valid_597029 = path.getOrDefault("subscriptionId")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "subscriptionId", valid_597029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597030 = query.getOrDefault("api-version")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "api-version", valid_597030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The create or update parameters for runbook. Provide either content link for a published runbook or draft, not both.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597032: Call_RunbookCreateOrUpdate_596997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  let valid = call_597032.validator(path, query, header, formData, body)
  let scheme = call_597032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597032.url(scheme.get, call_597032.host, call_597032.base,
                         call_597032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597032, url, valid)

proc call*(call_597033: Call_RunbookCreateOrUpdate_596997;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## runbookCreateOrUpdate
  ## Create the runbook identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The create or update parameters for runbook. Provide either content link for a published runbook or draft, not both.
  var path_597034 = newJObject()
  var query_597035 = newJObject()
  var body_597036 = newJObject()
  add(path_597034, "automationAccountName", newJString(automationAccountName))
  add(path_597034, "resourceGroupName", newJString(resourceGroupName))
  add(path_597034, "runbookName", newJString(runbookName))
  add(query_597035, "api-version", newJString(apiVersion))
  add(path_597034, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597036 = parameters
  result = call_597033.call(path_597034, query_597035, nil, nil, body_597036)

var runbookCreateOrUpdate* = Call_RunbookCreateOrUpdate_596997(
    name: "runbookCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}",
    validator: validate_RunbookCreateOrUpdate_596998, base: "",
    url: url_RunbookCreateOrUpdate_596999, schemes: {Scheme.Https})
type
  Call_RunbookGet_596985 = ref object of OpenApiRestCall_596458
proc url_RunbookGet_596987(protocol: Scheme; host: string; base: string; route: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookGet_596986(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596988 = path.getOrDefault("automationAccountName")
  valid_596988 = validateParameter(valid_596988, JString, required = true,
                                 default = nil)
  if valid_596988 != nil:
    section.add "automationAccountName", valid_596988
  var valid_596989 = path.getOrDefault("resourceGroupName")
  valid_596989 = validateParameter(valid_596989, JString, required = true,
                                 default = nil)
  if valid_596989 != nil:
    section.add "resourceGroupName", valid_596989
  var valid_596990 = path.getOrDefault("runbookName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "runbookName", valid_596990
  var valid_596991 = path.getOrDefault("subscriptionId")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "subscriptionId", valid_596991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596992 = query.getOrDefault("api-version")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "api-version", valid_596992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596993: Call_RunbookGet_596985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  let valid = call_596993.validator(path, query, header, formData, body)
  let scheme = call_596993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596993.url(scheme.get, call_596993.host, call_596993.base,
                         call_596993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596993, url, valid)

proc call*(call_596994: Call_RunbookGet_596985; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## runbookGet
  ## Retrieve the runbook identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596995 = newJObject()
  var query_596996 = newJObject()
  add(path_596995, "automationAccountName", newJString(automationAccountName))
  add(path_596995, "resourceGroupName", newJString(resourceGroupName))
  add(path_596995, "runbookName", newJString(runbookName))
  add(query_596996, "api-version", newJString(apiVersion))
  add(path_596995, "subscriptionId", newJString(subscriptionId))
  result = call_596994.call(path_596995, query_596996, nil, nil, nil)

var runbookGet* = Call_RunbookGet_596985(name: "runbookGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}",
                                      validator: validate_RunbookGet_596986,
                                      base: "", url: url_RunbookGet_596987,
                                      schemes: {Scheme.Https})
type
  Call_RunbookUpdate_597049 = ref object of OpenApiRestCall_596458
proc url_RunbookUpdate_597051(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookUpdate_597050(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597052 = path.getOrDefault("automationAccountName")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "automationAccountName", valid_597052
  var valid_597053 = path.getOrDefault("resourceGroupName")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "resourceGroupName", valid_597053
  var valid_597054 = path.getOrDefault("runbookName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "runbookName", valid_597054
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The update parameters for runbook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597058: Call_RunbookUpdate_597049; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  let valid = call_597058.validator(path, query, header, formData, body)
  let scheme = call_597058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597058.url(scheme.get, call_597058.host, call_597058.base,
                         call_597058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597058, url, valid)

proc call*(call_597059: Call_RunbookUpdate_597049; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## runbookUpdate
  ## Update the runbook identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The update parameters for runbook.
  var path_597060 = newJObject()
  var query_597061 = newJObject()
  var body_597062 = newJObject()
  add(path_597060, "automationAccountName", newJString(automationAccountName))
  add(path_597060, "resourceGroupName", newJString(resourceGroupName))
  add(path_597060, "runbookName", newJString(runbookName))
  add(query_597061, "api-version", newJString(apiVersion))
  add(path_597060, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597062 = parameters
  result = call_597059.call(path_597060, query_597061, nil, nil, body_597062)

var runbookUpdate* = Call_RunbookUpdate_597049(name: "runbookUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}",
    validator: validate_RunbookUpdate_597050, base: "", url: url_RunbookUpdate_597051,
    schemes: {Scheme.Https})
type
  Call_RunbookDelete_597037 = ref object of OpenApiRestCall_596458
proc url_RunbookDelete_597039(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookDelete_597038(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the runbook by name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
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
  var valid_597042 = path.getOrDefault("runbookName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "runbookName", valid_597042
  var valid_597043 = path.getOrDefault("subscriptionId")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "subscriptionId", valid_597043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597044 = query.getOrDefault("api-version")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "api-version", valid_597044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_RunbookDelete_597037; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the runbook by name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_RunbookDelete_597037; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## runbookDelete
  ## Delete the runbook by name.
  ## http://aka.ms/azureautomationsdk/runbookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  add(path_597047, "automationAccountName", newJString(automationAccountName))
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(path_597047, "runbookName", newJString(runbookName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  result = call_597046.call(path_597047, query_597048, nil, nil, nil)

var runbookDelete* = Call_RunbookDelete_597037(name: "runbookDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}",
    validator: validate_RunbookDelete_597038, base: "", url: url_RunbookDelete_597039,
    schemes: {Scheme.Https})
type
  Call_RunbookGetContent_597063 = ref object of OpenApiRestCall_596458
proc url_RunbookGetContent_597065(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookGetContent_597064(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieve the content of runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597066 = path.getOrDefault("automationAccountName")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "automationAccountName", valid_597066
  var valid_597067 = path.getOrDefault("resourceGroupName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "resourceGroupName", valid_597067
  var valid_597068 = path.getOrDefault("runbookName")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "runbookName", valid_597068
  var valid_597069 = path.getOrDefault("subscriptionId")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "subscriptionId", valid_597069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597070 = query.getOrDefault("api-version")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "api-version", valid_597070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597071: Call_RunbookGetContent_597063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the content of runbook identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookoperations
  let valid = call_597071.validator(path, query, header, formData, body)
  let scheme = call_597071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597071.url(scheme.get, call_597071.host, call_597071.base,
                         call_597071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597071, url, valid)

proc call*(call_597072: Call_RunbookGetContent_597063;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## runbookGetContent
  ## Retrieve the content of runbook identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597073 = newJObject()
  var query_597074 = newJObject()
  add(path_597073, "automationAccountName", newJString(automationAccountName))
  add(path_597073, "resourceGroupName", newJString(resourceGroupName))
  add(path_597073, "runbookName", newJString(runbookName))
  add(query_597074, "api-version", newJString(apiVersion))
  add(path_597073, "subscriptionId", newJString(subscriptionId))
  result = call_597072.call(path_597073, query_597074, nil, nil, nil)

var runbookGetContent* = Call_RunbookGetContent_597063(name: "runbookGetContent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/content",
    validator: validate_RunbookGetContent_597064, base: "",
    url: url_RunbookGetContent_597065, schemes: {Scheme.Https})
type
  Call_RunbookDraftGet_597075 = ref object of OpenApiRestCall_596458
proc url_RunbookDraftGet_597077(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookDraftGet_597076(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieve the runbook draft identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597078 = path.getOrDefault("automationAccountName")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "automationAccountName", valid_597078
  var valid_597079 = path.getOrDefault("resourceGroupName")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "resourceGroupName", valid_597079
  var valid_597080 = path.getOrDefault("runbookName")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "runbookName", valid_597080
  var valid_597081 = path.getOrDefault("subscriptionId")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "subscriptionId", valid_597081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597082 = query.getOrDefault("api-version")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "api-version", valid_597082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597083: Call_RunbookDraftGet_597075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the runbook draft identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  let valid = call_597083.validator(path, query, header, formData, body)
  let scheme = call_597083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597083.url(scheme.get, call_597083.host, call_597083.base,
                         call_597083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597083, url, valid)

proc call*(call_597084: Call_RunbookDraftGet_597075; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## runbookDraftGet
  ## Retrieve the runbook draft identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597085 = newJObject()
  var query_597086 = newJObject()
  add(path_597085, "automationAccountName", newJString(automationAccountName))
  add(path_597085, "resourceGroupName", newJString(resourceGroupName))
  add(path_597085, "runbookName", newJString(runbookName))
  add(query_597086, "api-version", newJString(apiVersion))
  add(path_597085, "subscriptionId", newJString(subscriptionId))
  result = call_597084.call(path_597085, query_597086, nil, nil, nil)

var runbookDraftGet* = Call_RunbookDraftGet_597075(name: "runbookDraftGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft",
    validator: validate_RunbookDraftGet_597076, base: "", url: url_RunbookDraftGet_597077,
    schemes: {Scheme.Https})
type
  Call_RunbookDraftReplaceContent_597099 = ref object of OpenApiRestCall_596458
proc url_RunbookDraftReplaceContent_597101(protocol: Scheme; host: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookDraftReplaceContent_597100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replaces the runbook draft content.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597102 = path.getOrDefault("automationAccountName")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "automationAccountName", valid_597102
  var valid_597103 = path.getOrDefault("resourceGroupName")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "resourceGroupName", valid_597103
  var valid_597104 = path.getOrDefault("runbookName")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "runbookName", valid_597104
  var valid_597105 = path.getOrDefault("subscriptionId")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "subscriptionId", valid_597105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597106 = query.getOrDefault("api-version")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "api-version", valid_597106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   runbookContent: JObject (required)
  ##                 : The runbook draft content.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597108: Call_RunbookDraftReplaceContent_597099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the runbook draft content.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  let valid = call_597108.validator(path, query, header, formData, body)
  let scheme = call_597108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597108.url(scheme.get, call_597108.host, call_597108.base,
                         call_597108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597108, url, valid)

proc call*(call_597109: Call_RunbookDraftReplaceContent_597099;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; runbookContent: JsonNode; apiVersion: string;
          subscriptionId: string): Recallable =
  ## runbookDraftReplaceContent
  ## Replaces the runbook draft content.
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   runbookContent: JObject (required)
  ##                 : The runbook draft content.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597110 = newJObject()
  var query_597111 = newJObject()
  var body_597112 = newJObject()
  add(path_597110, "automationAccountName", newJString(automationAccountName))
  add(path_597110, "resourceGroupName", newJString(resourceGroupName))
  add(path_597110, "runbookName", newJString(runbookName))
  if runbookContent != nil:
    body_597112 = runbookContent
  add(query_597111, "api-version", newJString(apiVersion))
  add(path_597110, "subscriptionId", newJString(subscriptionId))
  result = call_597109.call(path_597110, query_597111, nil, nil, body_597112)

var runbookDraftReplaceContent* = Call_RunbookDraftReplaceContent_597099(
    name: "runbookDraftReplaceContent", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/content",
    validator: validate_RunbookDraftReplaceContent_597100, base: "",
    url: url_RunbookDraftReplaceContent_597101, schemes: {Scheme.Https})
type
  Call_RunbookDraftGetContent_597087 = ref object of OpenApiRestCall_596458
proc url_RunbookDraftGetContent_597089(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookDraftGetContent_597088(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the content of runbook draft identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597090 = path.getOrDefault("automationAccountName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "automationAccountName", valid_597090
  var valid_597091 = path.getOrDefault("resourceGroupName")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "resourceGroupName", valid_597091
  var valid_597092 = path.getOrDefault("runbookName")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "runbookName", valid_597092
  var valid_597093 = path.getOrDefault("subscriptionId")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "subscriptionId", valid_597093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597094 = query.getOrDefault("api-version")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "api-version", valid_597094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597095: Call_RunbookDraftGetContent_597087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the content of runbook draft identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  let valid = call_597095.validator(path, query, header, formData, body)
  let scheme = call_597095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597095.url(scheme.get, call_597095.host, call_597095.base,
                         call_597095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597095, url, valid)

proc call*(call_597096: Call_RunbookDraftGetContent_597087;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## runbookDraftGetContent
  ## Retrieve the content of runbook draft identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597097 = newJObject()
  var query_597098 = newJObject()
  add(path_597097, "automationAccountName", newJString(automationAccountName))
  add(path_597097, "resourceGroupName", newJString(resourceGroupName))
  add(path_597097, "runbookName", newJString(runbookName))
  add(query_597098, "api-version", newJString(apiVersion))
  add(path_597097, "subscriptionId", newJString(subscriptionId))
  result = call_597096.call(path_597097, query_597098, nil, nil, nil)

var runbookDraftGetContent* = Call_RunbookDraftGetContent_597087(
    name: "runbookDraftGetContent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/content",
    validator: validate_RunbookDraftGetContent_597088, base: "",
    url: url_RunbookDraftGetContent_597089, schemes: {Scheme.Https})
type
  Call_RunbookDraftPublish_597113 = ref object of OpenApiRestCall_596458
proc url_RunbookDraftPublish_597115(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookDraftPublish_597114(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Publish runbook draft.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The parameters supplied to the publish runbook operation.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597116 = path.getOrDefault("automationAccountName")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "automationAccountName", valid_597116
  var valid_597117 = path.getOrDefault("resourceGroupName")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "resourceGroupName", valid_597117
  var valid_597118 = path.getOrDefault("runbookName")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = nil)
  if valid_597118 != nil:
    section.add "runbookName", valid_597118
  var valid_597119 = path.getOrDefault("subscriptionId")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "subscriptionId", valid_597119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597120 = query.getOrDefault("api-version")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "api-version", valid_597120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597121: Call_RunbookDraftPublish_597113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish runbook draft.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  let valid = call_597121.validator(path, query, header, formData, body)
  let scheme = call_597121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597121.url(scheme.get, call_597121.host, call_597121.base,
                         call_597121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597121, url, valid)

proc call*(call_597122: Call_RunbookDraftPublish_597113;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## runbookDraftPublish
  ## Publish runbook draft.
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The parameters supplied to the publish runbook operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597123 = newJObject()
  var query_597124 = newJObject()
  add(path_597123, "automationAccountName", newJString(automationAccountName))
  add(path_597123, "resourceGroupName", newJString(resourceGroupName))
  add(path_597123, "runbookName", newJString(runbookName))
  add(query_597124, "api-version", newJString(apiVersion))
  add(path_597123, "subscriptionId", newJString(subscriptionId))
  result = call_597122.call(path_597123, query_597124, nil, nil, nil)

var runbookDraftPublish* = Call_RunbookDraftPublish_597113(
    name: "runbookDraftPublish", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/publish",
    validator: validate_RunbookDraftPublish_597114, base: "",
    url: url_RunbookDraftPublish_597115, schemes: {Scheme.Https})
type
  Call_TestJobCreate_597137 = ref object of OpenApiRestCall_596458
proc url_TestJobCreate_597139(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobCreate_597138(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a test job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The parameters supplied to the create test job operation.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597140 = path.getOrDefault("automationAccountName")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "automationAccountName", valid_597140
  var valid_597141 = path.getOrDefault("resourceGroupName")
  valid_597141 = validateParameter(valid_597141, JString, required = true,
                                 default = nil)
  if valid_597141 != nil:
    section.add "resourceGroupName", valid_597141
  var valid_597142 = path.getOrDefault("runbookName")
  valid_597142 = validateParameter(valid_597142, JString, required = true,
                                 default = nil)
  if valid_597142 != nil:
    section.add "runbookName", valid_597142
  var valid_597143 = path.getOrDefault("subscriptionId")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "subscriptionId", valid_597143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597144 = query.getOrDefault("api-version")
  valid_597144 = validateParameter(valid_597144, JString, required = true,
                                 default = nil)
  if valid_597144 != nil:
    section.add "api-version", valid_597144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create test job operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597146: Call_TestJobCreate_597137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a test job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  let valid = call_597146.validator(path, query, header, formData, body)
  let scheme = call_597146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597146.url(scheme.get, call_597146.host, call_597146.base,
                         call_597146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597146, url, valid)

proc call*(call_597147: Call_TestJobCreate_597137; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## testJobCreate
  ## Create a test job of the runbook.
  ## http://aka.ms/azureautomationsdk/testjoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The parameters supplied to the create test job operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create test job operation.
  var path_597148 = newJObject()
  var query_597149 = newJObject()
  var body_597150 = newJObject()
  add(path_597148, "automationAccountName", newJString(automationAccountName))
  add(path_597148, "resourceGroupName", newJString(resourceGroupName))
  add(path_597148, "runbookName", newJString(runbookName))
  add(query_597149, "api-version", newJString(apiVersion))
  add(path_597148, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597150 = parameters
  result = call_597147.call(path_597148, query_597149, nil, nil, body_597150)

var testJobCreate* = Call_TestJobCreate_597137(name: "testJobCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob",
    validator: validate_TestJobCreate_597138, base: "", url: url_TestJobCreate_597139,
    schemes: {Scheme.Https})
type
  Call_TestJobGet_597125 = ref object of OpenApiRestCall_596458
proc url_TestJobGet_597127(protocol: Scheme; host: string; base: string; route: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobGet_597126(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the test job for the specified runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597128 = path.getOrDefault("automationAccountName")
  valid_597128 = validateParameter(valid_597128, JString, required = true,
                                 default = nil)
  if valid_597128 != nil:
    section.add "automationAccountName", valid_597128
  var valid_597129 = path.getOrDefault("resourceGroupName")
  valid_597129 = validateParameter(valid_597129, JString, required = true,
                                 default = nil)
  if valid_597129 != nil:
    section.add "resourceGroupName", valid_597129
  var valid_597130 = path.getOrDefault("runbookName")
  valid_597130 = validateParameter(valid_597130, JString, required = true,
                                 default = nil)
  if valid_597130 != nil:
    section.add "runbookName", valid_597130
  var valid_597131 = path.getOrDefault("subscriptionId")
  valid_597131 = validateParameter(valid_597131, JString, required = true,
                                 default = nil)
  if valid_597131 != nil:
    section.add "subscriptionId", valid_597131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597132 = query.getOrDefault("api-version")
  valid_597132 = validateParameter(valid_597132, JString, required = true,
                                 default = nil)
  if valid_597132 != nil:
    section.add "api-version", valid_597132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597133: Call_TestJobGet_597125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the test job for the specified runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  let valid = call_597133.validator(path, query, header, formData, body)
  let scheme = call_597133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597133.url(scheme.get, call_597133.host, call_597133.base,
                         call_597133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597133, url, valid)

proc call*(call_597134: Call_TestJobGet_597125; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## testJobGet
  ## Retrieve the test job for the specified runbook.
  ## http://aka.ms/azureautomationsdk/testjoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597135 = newJObject()
  var query_597136 = newJObject()
  add(path_597135, "automationAccountName", newJString(automationAccountName))
  add(path_597135, "resourceGroupName", newJString(resourceGroupName))
  add(path_597135, "runbookName", newJString(runbookName))
  add(query_597136, "api-version", newJString(apiVersion))
  add(path_597135, "subscriptionId", newJString(subscriptionId))
  result = call_597134.call(path_597135, query_597136, nil, nil, nil)

var testJobGet* = Call_TestJobGet_597125(name: "testJobGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob",
                                      validator: validate_TestJobGet_597126,
                                      base: "", url: url_TestJobGet_597127,
                                      schemes: {Scheme.Https})
type
  Call_TestJobResume_597151 = ref object of OpenApiRestCall_596458
proc url_TestJobResume_597153(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobResume_597152(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume the test job.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597154 = path.getOrDefault("automationAccountName")
  valid_597154 = validateParameter(valid_597154, JString, required = true,
                                 default = nil)
  if valid_597154 != nil:
    section.add "automationAccountName", valid_597154
  var valid_597155 = path.getOrDefault("resourceGroupName")
  valid_597155 = validateParameter(valid_597155, JString, required = true,
                                 default = nil)
  if valid_597155 != nil:
    section.add "resourceGroupName", valid_597155
  var valid_597156 = path.getOrDefault("runbookName")
  valid_597156 = validateParameter(valid_597156, JString, required = true,
                                 default = nil)
  if valid_597156 != nil:
    section.add "runbookName", valid_597156
  var valid_597157 = path.getOrDefault("subscriptionId")
  valid_597157 = validateParameter(valid_597157, JString, required = true,
                                 default = nil)
  if valid_597157 != nil:
    section.add "subscriptionId", valid_597157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597158 = query.getOrDefault("api-version")
  valid_597158 = validateParameter(valid_597158, JString, required = true,
                                 default = nil)
  if valid_597158 != nil:
    section.add "api-version", valid_597158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597159: Call_TestJobResume_597151; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume the test job.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  let valid = call_597159.validator(path, query, header, formData, body)
  let scheme = call_597159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597159.url(scheme.get, call_597159.host, call_597159.base,
                         call_597159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597159, url, valid)

proc call*(call_597160: Call_TestJobResume_597151; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## testJobResume
  ## Resume the test job.
  ## http://aka.ms/azureautomationsdk/testjoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597161 = newJObject()
  var query_597162 = newJObject()
  add(path_597161, "automationAccountName", newJString(automationAccountName))
  add(path_597161, "resourceGroupName", newJString(resourceGroupName))
  add(path_597161, "runbookName", newJString(runbookName))
  add(query_597162, "api-version", newJString(apiVersion))
  add(path_597161, "subscriptionId", newJString(subscriptionId))
  result = call_597160.call(path_597161, query_597162, nil, nil, nil)

var testJobResume* = Call_TestJobResume_597151(name: "testJobResume",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob/resume",
    validator: validate_TestJobResume_597152, base: "", url: url_TestJobResume_597153,
    schemes: {Scheme.Https})
type
  Call_TestJobStop_597163 = ref object of OpenApiRestCall_596458
proc url_TestJobStop_597165(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobStop_597164(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Stop the test job.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597166 = path.getOrDefault("automationAccountName")
  valid_597166 = validateParameter(valid_597166, JString, required = true,
                                 default = nil)
  if valid_597166 != nil:
    section.add "automationAccountName", valid_597166
  var valid_597167 = path.getOrDefault("resourceGroupName")
  valid_597167 = validateParameter(valid_597167, JString, required = true,
                                 default = nil)
  if valid_597167 != nil:
    section.add "resourceGroupName", valid_597167
  var valid_597168 = path.getOrDefault("runbookName")
  valid_597168 = validateParameter(valid_597168, JString, required = true,
                                 default = nil)
  if valid_597168 != nil:
    section.add "runbookName", valid_597168
  var valid_597169 = path.getOrDefault("subscriptionId")
  valid_597169 = validateParameter(valid_597169, JString, required = true,
                                 default = nil)
  if valid_597169 != nil:
    section.add "subscriptionId", valid_597169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597170 = query.getOrDefault("api-version")
  valid_597170 = validateParameter(valid_597170, JString, required = true,
                                 default = nil)
  if valid_597170 != nil:
    section.add "api-version", valid_597170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597171: Call_TestJobStop_597163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop the test job.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  let valid = call_597171.validator(path, query, header, formData, body)
  let scheme = call_597171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597171.url(scheme.get, call_597171.host, call_597171.base,
                         call_597171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597171, url, valid)

proc call*(call_597172: Call_TestJobStop_597163; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## testJobStop
  ## Stop the test job.
  ## http://aka.ms/azureautomationsdk/testjoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597173 = newJObject()
  var query_597174 = newJObject()
  add(path_597173, "automationAccountName", newJString(automationAccountName))
  add(path_597173, "resourceGroupName", newJString(resourceGroupName))
  add(path_597173, "runbookName", newJString(runbookName))
  add(query_597174, "api-version", newJString(apiVersion))
  add(path_597173, "subscriptionId", newJString(subscriptionId))
  result = call_597172.call(path_597173, query_597174, nil, nil, nil)

var testJobStop* = Call_TestJobStop_597163(name: "testJobStop",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob/stop",
                                        validator: validate_TestJobStop_597164,
                                        base: "", url: url_TestJobStop_597165,
                                        schemes: {Scheme.Https})
type
  Call_TestJobStreamsListByTestJob_597175 = ref object of OpenApiRestCall_596458
proc url_TestJobStreamsListByTestJob_597177(protocol: Scheme; host: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob/streams")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobStreamsListByTestJob_597176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of test job streams identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597179 = path.getOrDefault("automationAccountName")
  valid_597179 = validateParameter(valid_597179, JString, required = true,
                                 default = nil)
  if valid_597179 != nil:
    section.add "automationAccountName", valid_597179
  var valid_597180 = path.getOrDefault("resourceGroupName")
  valid_597180 = validateParameter(valid_597180, JString, required = true,
                                 default = nil)
  if valid_597180 != nil:
    section.add "resourceGroupName", valid_597180
  var valid_597181 = path.getOrDefault("runbookName")
  valid_597181 = validateParameter(valid_597181, JString, required = true,
                                 default = nil)
  if valid_597181 != nil:
    section.add "runbookName", valid_597181
  var valid_597182 = path.getOrDefault("subscriptionId")
  valid_597182 = validateParameter(valid_597182, JString, required = true,
                                 default = nil)
  if valid_597182 != nil:
    section.add "subscriptionId", valid_597182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597183 = query.getOrDefault("api-version")
  valid_597183 = validateParameter(valid_597183, JString, required = true,
                                 default = nil)
  if valid_597183 != nil:
    section.add "api-version", valid_597183
  var valid_597184 = query.getOrDefault("$filter")
  valid_597184 = validateParameter(valid_597184, JString, required = false,
                                 default = nil)
  if valid_597184 != nil:
    section.add "$filter", valid_597184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597185: Call_TestJobStreamsListByTestJob_597175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of test job streams identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_597185.validator(path, query, header, formData, body)
  let scheme = call_597185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597185.url(scheme.get, call_597185.host, call_597185.base,
                         call_597185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597185, url, valid)

proc call*(call_597186: Call_TestJobStreamsListByTestJob_597175;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## testJobStreamsListByTestJob
  ## Retrieve a list of test job streams identified by runbook name.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597187 = newJObject()
  var query_597188 = newJObject()
  add(path_597187, "automationAccountName", newJString(automationAccountName))
  add(path_597187, "resourceGroupName", newJString(resourceGroupName))
  add(path_597187, "runbookName", newJString(runbookName))
  add(query_597188, "api-version", newJString(apiVersion))
  add(path_597187, "subscriptionId", newJString(subscriptionId))
  add(query_597188, "$filter", newJString(Filter))
  result = call_597186.call(path_597187, query_597188, nil, nil, nil)

var testJobStreamsListByTestJob* = Call_TestJobStreamsListByTestJob_597175(
    name: "testJobStreamsListByTestJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob/streams",
    validator: validate_TestJobStreamsListByTestJob_597176, base: "",
    url: url_TestJobStreamsListByTestJob_597177, schemes: {Scheme.Https})
type
  Call_TestJobStreamsGet_597189 = ref object of OpenApiRestCall_596458
proc url_TestJobStreamsGet_597191(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  assert "jobStreamId" in path, "`jobStreamId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob/streams/"),
               (kind: VariableSegment, value: "jobStreamId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobStreamsGet_597190(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieve a test job stream of the test job identified by runbook name and stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobStreamId: JString (required)
  ##              : The job stream id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597192 = path.getOrDefault("automationAccountName")
  valid_597192 = validateParameter(valid_597192, JString, required = true,
                                 default = nil)
  if valid_597192 != nil:
    section.add "automationAccountName", valid_597192
  var valid_597193 = path.getOrDefault("resourceGroupName")
  valid_597193 = validateParameter(valid_597193, JString, required = true,
                                 default = nil)
  if valid_597193 != nil:
    section.add "resourceGroupName", valid_597193
  var valid_597194 = path.getOrDefault("runbookName")
  valid_597194 = validateParameter(valid_597194, JString, required = true,
                                 default = nil)
  if valid_597194 != nil:
    section.add "runbookName", valid_597194
  var valid_597195 = path.getOrDefault("subscriptionId")
  valid_597195 = validateParameter(valid_597195, JString, required = true,
                                 default = nil)
  if valid_597195 != nil:
    section.add "subscriptionId", valid_597195
  var valid_597196 = path.getOrDefault("jobStreamId")
  valid_597196 = validateParameter(valid_597196, JString, required = true,
                                 default = nil)
  if valid_597196 != nil:
    section.add "jobStreamId", valid_597196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597197 = query.getOrDefault("api-version")
  valid_597197 = validateParameter(valid_597197, JString, required = true,
                                 default = nil)
  if valid_597197 != nil:
    section.add "api-version", valid_597197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597198: Call_TestJobStreamsGet_597189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a test job stream of the test job identified by runbook name and stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_597198.validator(path, query, header, formData, body)
  let scheme = call_597198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597198.url(scheme.get, call_597198.host, call_597198.base,
                         call_597198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597198, url, valid)

proc call*(call_597199: Call_TestJobStreamsGet_597189;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string;
          jobStreamId: string): Recallable =
  ## testJobStreamsGet
  ## Retrieve a test job stream of the test job identified by runbook name and stream id.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobStreamId: string (required)
  ##              : The job stream id.
  var path_597200 = newJObject()
  var query_597201 = newJObject()
  add(path_597200, "automationAccountName", newJString(automationAccountName))
  add(path_597200, "resourceGroupName", newJString(resourceGroupName))
  add(path_597200, "runbookName", newJString(runbookName))
  add(query_597201, "api-version", newJString(apiVersion))
  add(path_597200, "subscriptionId", newJString(subscriptionId))
  add(path_597200, "jobStreamId", newJString(jobStreamId))
  result = call_597199.call(path_597200, query_597201, nil, nil, nil)

var testJobStreamsGet* = Call_TestJobStreamsGet_597189(name: "testJobStreamsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob/streams/{jobStreamId}",
    validator: validate_TestJobStreamsGet_597190, base: "",
    url: url_TestJobStreamsGet_597191, schemes: {Scheme.Https})
type
  Call_TestJobSuspend_597202 = ref object of OpenApiRestCall_596458
proc url_TestJobSuspend_597204(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/testJob/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestJobSuspend_597203(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Suspend the test job.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597205 = path.getOrDefault("automationAccountName")
  valid_597205 = validateParameter(valid_597205, JString, required = true,
                                 default = nil)
  if valid_597205 != nil:
    section.add "automationAccountName", valid_597205
  var valid_597206 = path.getOrDefault("resourceGroupName")
  valid_597206 = validateParameter(valid_597206, JString, required = true,
                                 default = nil)
  if valid_597206 != nil:
    section.add "resourceGroupName", valid_597206
  var valid_597207 = path.getOrDefault("runbookName")
  valid_597207 = validateParameter(valid_597207, JString, required = true,
                                 default = nil)
  if valid_597207 != nil:
    section.add "runbookName", valid_597207
  var valid_597208 = path.getOrDefault("subscriptionId")
  valid_597208 = validateParameter(valid_597208, JString, required = true,
                                 default = nil)
  if valid_597208 != nil:
    section.add "subscriptionId", valid_597208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597209 = query.getOrDefault("api-version")
  valid_597209 = validateParameter(valid_597209, JString, required = true,
                                 default = nil)
  if valid_597209 != nil:
    section.add "api-version", valid_597209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597210: Call_TestJobSuspend_597202; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend the test job.
  ## 
  ## http://aka.ms/azureautomationsdk/testjoboperations
  let valid = call_597210.validator(path, query, header, formData, body)
  let scheme = call_597210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597210.url(scheme.get, call_597210.host, call_597210.base,
                         call_597210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597210, url, valid)

proc call*(call_597211: Call_TestJobSuspend_597202; automationAccountName: string;
          resourceGroupName: string; runbookName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## testJobSuspend
  ## Suspend the test job.
  ## http://aka.ms/azureautomationsdk/testjoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597212 = newJObject()
  var query_597213 = newJObject()
  add(path_597212, "automationAccountName", newJString(automationAccountName))
  add(path_597212, "resourceGroupName", newJString(resourceGroupName))
  add(path_597212, "runbookName", newJString(runbookName))
  add(query_597213, "api-version", newJString(apiVersion))
  add(path_597212, "subscriptionId", newJString(subscriptionId))
  result = call_597211.call(path_597212, query_597213, nil, nil, nil)

var testJobSuspend* = Call_TestJobSuspend_597202(name: "testJobSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/testJob/suspend",
    validator: validate_TestJobSuspend_597203, base: "", url: url_TestJobSuspend_597204,
    schemes: {Scheme.Https})
type
  Call_RunbookDraftUndoEdit_597214 = ref object of OpenApiRestCall_596458
proc url_RunbookDraftUndoEdit_597216(protocol: Scheme; host: string; base: string;
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
  assert "runbookName" in path, "`runbookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/runbooks/"),
               (kind: VariableSegment, value: "runbookName"),
               (kind: ConstantSegment, value: "/draft/undoEdit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunbookDraftUndoEdit_597215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undo draft edit to last known published state identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: JString (required)
  ##              : The runbook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597217 = path.getOrDefault("automationAccountName")
  valid_597217 = validateParameter(valid_597217, JString, required = true,
                                 default = nil)
  if valid_597217 != nil:
    section.add "automationAccountName", valid_597217
  var valid_597218 = path.getOrDefault("resourceGroupName")
  valid_597218 = validateParameter(valid_597218, JString, required = true,
                                 default = nil)
  if valid_597218 != nil:
    section.add "resourceGroupName", valid_597218
  var valid_597219 = path.getOrDefault("runbookName")
  valid_597219 = validateParameter(valid_597219, JString, required = true,
                                 default = nil)
  if valid_597219 != nil:
    section.add "runbookName", valid_597219
  var valid_597220 = path.getOrDefault("subscriptionId")
  valid_597220 = validateParameter(valid_597220, JString, required = true,
                                 default = nil)
  if valid_597220 != nil:
    section.add "subscriptionId", valid_597220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597221 = query.getOrDefault("api-version")
  valid_597221 = validateParameter(valid_597221, JString, required = true,
                                 default = nil)
  if valid_597221 != nil:
    section.add "api-version", valid_597221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597222: Call_RunbookDraftUndoEdit_597214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undo draft edit to last known published state identified by runbook name.
  ## 
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  let valid = call_597222.validator(path, query, header, formData, body)
  let scheme = call_597222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597222.url(scheme.get, call_597222.host, call_597222.base,
                         call_597222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597222, url, valid)

proc call*(call_597223: Call_RunbookDraftUndoEdit_597214;
          automationAccountName: string; resourceGroupName: string;
          runbookName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## runbookDraftUndoEdit
  ## Undo draft edit to last known published state identified by runbook name.
  ## http://aka.ms/azureautomationsdk/runbookdraftoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   runbookName: string (required)
  ##              : The runbook name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597224 = newJObject()
  var query_597225 = newJObject()
  add(path_597224, "automationAccountName", newJString(automationAccountName))
  add(path_597224, "resourceGroupName", newJString(resourceGroupName))
  add(path_597224, "runbookName", newJString(runbookName))
  add(query_597225, "api-version", newJString(apiVersion))
  add(path_597224, "subscriptionId", newJString(subscriptionId))
  result = call_597223.call(path_597224, query_597225, nil, nil, nil)

var runbookDraftUndoEdit* = Call_RunbookDraftUndoEdit_597214(
    name: "runbookDraftUndoEdit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/runbooks/{runbookName}/draft/undoEdit",
    validator: validate_RunbookDraftUndoEdit_597215, base: "",
    url: url_RunbookDraftUndoEdit_597216, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
