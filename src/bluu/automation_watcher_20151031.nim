
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
  macServiceName = "automation-watcher"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WatcherListByAutomationAccount_596680 = ref object of OpenApiRestCall_596458
proc url_WatcherListByAutomationAccount_596682(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/watchers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherListByAutomationAccount_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of watchers.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
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
  var valid_596847 = query.getOrDefault("$filter")
  valid_596847 = validateParameter(valid_596847, JString, required = false,
                                 default = nil)
  if valid_596847 != nil:
    section.add "$filter", valid_596847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596874: Call_WatcherListByAutomationAccount_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of watchers.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_596874.validator(path, query, header, formData, body)
  let scheme = call_596874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596874.url(scheme.get, call_596874.host, call_596874.base,
                         call_596874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596874, url, valid)

proc call*(call_596945: Call_WatcherListByAutomationAccount_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## watcherListByAutomationAccount
  ## Retrieve a list of watchers.
  ## http://aka.ms/azureautomationsdk/watcheroperations
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
  var path_596946 = newJObject()
  var query_596948 = newJObject()
  add(path_596946, "automationAccountName", newJString(automationAccountName))
  add(path_596946, "resourceGroupName", newJString(resourceGroupName))
  add(query_596948, "api-version", newJString(apiVersion))
  add(path_596946, "subscriptionId", newJString(subscriptionId))
  add(query_596948, "$filter", newJString(Filter))
  result = call_596945.call(path_596946, query_596948, nil, nil, nil)

var watcherListByAutomationAccount* = Call_WatcherListByAutomationAccount_596680(
    name: "watcherListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers",
    validator: validate_WatcherListByAutomationAccount_596681, base: "",
    url: url_WatcherListByAutomationAccount_596682, schemes: {Scheme.Https})
type
  Call_WatcherCreateOrUpdate_596999 = ref object of OpenApiRestCall_596458
proc url_WatcherCreateOrUpdate_597001(protocol: Scheme; host: string; base: string;
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
  assert "watcherName" in path, "`watcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/watchers/"),
               (kind: VariableSegment, value: "watcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherCreateOrUpdate_597000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: JString (required)
  ##              : The watcher name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597028 = path.getOrDefault("automationAccountName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "automationAccountName", valid_597028
  var valid_597029 = path.getOrDefault("resourceGroupName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "resourceGroupName", valid_597029
  var valid_597030 = path.getOrDefault("subscriptionId")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "subscriptionId", valid_597030
  var valid_597031 = path.getOrDefault("watcherName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "watcherName", valid_597031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597032 = query.getOrDefault("api-version")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "api-version", valid_597032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The create or update parameters for watcher.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597034: Call_WatcherCreateOrUpdate_596999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_597034.validator(path, query, header, formData, body)
  let scheme = call_597034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597034.url(scheme.get, call_597034.host, call_597034.base,
                         call_597034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597034, url, valid)

proc call*(call_597035: Call_WatcherCreateOrUpdate_596999;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; watcherName: string;
          parameters: JsonNode): Recallable =
  ## watcherCreateOrUpdate
  ## Create the watcher identified by watcher name.
  ## http://aka.ms/azureautomationsdk/watcheroperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: string (required)
  ##              : The watcher name.
  ##   parameters: JObject (required)
  ##             : The create or update parameters for watcher.
  var path_597036 = newJObject()
  var query_597037 = newJObject()
  var body_597038 = newJObject()
  add(path_597036, "automationAccountName", newJString(automationAccountName))
  add(path_597036, "resourceGroupName", newJString(resourceGroupName))
  add(query_597037, "api-version", newJString(apiVersion))
  add(path_597036, "subscriptionId", newJString(subscriptionId))
  add(path_597036, "watcherName", newJString(watcherName))
  if parameters != nil:
    body_597038 = parameters
  result = call_597035.call(path_597036, query_597037, nil, nil, body_597038)

var watcherCreateOrUpdate* = Call_WatcherCreateOrUpdate_596999(
    name: "watcherCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers/{watcherName}",
    validator: validate_WatcherCreateOrUpdate_597000, base: "",
    url: url_WatcherCreateOrUpdate_597001, schemes: {Scheme.Https})
type
  Call_WatcherGet_596987 = ref object of OpenApiRestCall_596458
proc url_WatcherGet_596989(protocol: Scheme; host: string; base: string; route: string;
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
  assert "watcherName" in path, "`watcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/watchers/"),
               (kind: VariableSegment, value: "watcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherGet_596988(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: JString (required)
  ##              : The watcher name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596990 = path.getOrDefault("automationAccountName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "automationAccountName", valid_596990
  var valid_596991 = path.getOrDefault("resourceGroupName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "resourceGroupName", valid_596991
  var valid_596992 = path.getOrDefault("subscriptionId")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "subscriptionId", valid_596992
  var valid_596993 = path.getOrDefault("watcherName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "watcherName", valid_596993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596994 = query.getOrDefault("api-version")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "api-version", valid_596994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596995: Call_WatcherGet_596987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_596995.validator(path, query, header, formData, body)
  let scheme = call_596995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596995.url(scheme.get, call_596995.host, call_596995.base,
                         call_596995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596995, url, valid)

proc call*(call_596996: Call_WatcherGet_596987; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          watcherName: string): Recallable =
  ## watcherGet
  ## Retrieve the watcher identified by watcher name.
  ## http://aka.ms/azureautomationsdk/watcheroperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: string (required)
  ##              : The watcher name.
  var path_596997 = newJObject()
  var query_596998 = newJObject()
  add(path_596997, "automationAccountName", newJString(automationAccountName))
  add(path_596997, "resourceGroupName", newJString(resourceGroupName))
  add(query_596998, "api-version", newJString(apiVersion))
  add(path_596997, "subscriptionId", newJString(subscriptionId))
  add(path_596997, "watcherName", newJString(watcherName))
  result = call_596996.call(path_596997, query_596998, nil, nil, nil)

var watcherGet* = Call_WatcherGet_596987(name: "watcherGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers/{watcherName}",
                                      validator: validate_WatcherGet_596988,
                                      base: "", url: url_WatcherGet_596989,
                                      schemes: {Scheme.Https})
type
  Call_WatcherUpdate_597051 = ref object of OpenApiRestCall_596458
proc url_WatcherUpdate_597053(protocol: Scheme; host: string; base: string;
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
  assert "watcherName" in path, "`watcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/watchers/"),
               (kind: VariableSegment, value: "watcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherUpdate_597052(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: JString (required)
  ##              : The watcher name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597054 = path.getOrDefault("automationAccountName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "automationAccountName", valid_597054
  var valid_597055 = path.getOrDefault("resourceGroupName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "resourceGroupName", valid_597055
  var valid_597056 = path.getOrDefault("subscriptionId")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "subscriptionId", valid_597056
  var valid_597057 = path.getOrDefault("watcherName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "watcherName", valid_597057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597058 = query.getOrDefault("api-version")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "api-version", valid_597058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The update parameters for watcher.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597060: Call_WatcherUpdate_597051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_597060.validator(path, query, header, formData, body)
  let scheme = call_597060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597060.url(scheme.get, call_597060.host, call_597060.base,
                         call_597060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597060, url, valid)

proc call*(call_597061: Call_WatcherUpdate_597051; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          watcherName: string; parameters: JsonNode): Recallable =
  ## watcherUpdate
  ## Update the watcher identified by watcher name.
  ## http://aka.ms/azureautomationsdk/watcheroperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: string (required)
  ##              : The watcher name.
  ##   parameters: JObject (required)
  ##             : The update parameters for watcher.
  var path_597062 = newJObject()
  var query_597063 = newJObject()
  var body_597064 = newJObject()
  add(path_597062, "automationAccountName", newJString(automationAccountName))
  add(path_597062, "resourceGroupName", newJString(resourceGroupName))
  add(query_597063, "api-version", newJString(apiVersion))
  add(path_597062, "subscriptionId", newJString(subscriptionId))
  add(path_597062, "watcherName", newJString(watcherName))
  if parameters != nil:
    body_597064 = parameters
  result = call_597061.call(path_597062, query_597063, nil, nil, body_597064)

var watcherUpdate* = Call_WatcherUpdate_597051(name: "watcherUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers/{watcherName}",
    validator: validate_WatcherUpdate_597052, base: "", url: url_WatcherUpdate_597053,
    schemes: {Scheme.Https})
type
  Call_WatcherDelete_597039 = ref object of OpenApiRestCall_596458
proc url_WatcherDelete_597041(protocol: Scheme; host: string; base: string;
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
  assert "watcherName" in path, "`watcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/watchers/"),
               (kind: VariableSegment, value: "watcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherDelete_597040(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the watcher by name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: JString (required)
  ##              : The watcher name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597042 = path.getOrDefault("automationAccountName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "automationAccountName", valid_597042
  var valid_597043 = path.getOrDefault("resourceGroupName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "resourceGroupName", valid_597043
  var valid_597044 = path.getOrDefault("subscriptionId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "subscriptionId", valid_597044
  var valid_597045 = path.getOrDefault("watcherName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "watcherName", valid_597045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597046 = query.getOrDefault("api-version")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "api-version", valid_597046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597047: Call_WatcherDelete_597039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the watcher by name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_597047.validator(path, query, header, formData, body)
  let scheme = call_597047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597047.url(scheme.get, call_597047.host, call_597047.base,
                         call_597047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597047, url, valid)

proc call*(call_597048: Call_WatcherDelete_597039; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          watcherName: string): Recallable =
  ## watcherDelete
  ## Delete the watcher by name.
  ## http://aka.ms/azureautomationsdk/watcheroperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: string (required)
  ##              : The watcher name.
  var path_597049 = newJObject()
  var query_597050 = newJObject()
  add(path_597049, "automationAccountName", newJString(automationAccountName))
  add(path_597049, "resourceGroupName", newJString(resourceGroupName))
  add(query_597050, "api-version", newJString(apiVersion))
  add(path_597049, "subscriptionId", newJString(subscriptionId))
  add(path_597049, "watcherName", newJString(watcherName))
  result = call_597048.call(path_597049, query_597050, nil, nil, nil)

var watcherDelete* = Call_WatcherDelete_597039(name: "watcherDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers/{watcherName}",
    validator: validate_WatcherDelete_597040, base: "", url: url_WatcherDelete_597041,
    schemes: {Scheme.Https})
type
  Call_WatcherStart_597065 = ref object of OpenApiRestCall_596458
proc url_WatcherStart_597067(protocol: Scheme; host: string; base: string;
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
  assert "watcherName" in path, "`watcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/watchers/"),
               (kind: VariableSegment, value: "watcherName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherStart_597066(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: JString (required)
  ##              : The watcher name.
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
  var valid_597071 = path.getOrDefault("watcherName")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "watcherName", valid_597071
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
  if body != nil:
    result.add "body", body

proc call*(call_597073: Call_WatcherStart_597065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_597073.validator(path, query, header, formData, body)
  let scheme = call_597073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597073.url(scheme.get, call_597073.host, call_597073.base,
                         call_597073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597073, url, valid)

proc call*(call_597074: Call_WatcherStart_597065; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          watcherName: string): Recallable =
  ## watcherStart
  ## Resume the watcher identified by watcher name.
  ## http://aka.ms/azureautomationsdk/watcheroperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: string (required)
  ##              : The watcher name.
  var path_597075 = newJObject()
  var query_597076 = newJObject()
  add(path_597075, "automationAccountName", newJString(automationAccountName))
  add(path_597075, "resourceGroupName", newJString(resourceGroupName))
  add(query_597076, "api-version", newJString(apiVersion))
  add(path_597075, "subscriptionId", newJString(subscriptionId))
  add(path_597075, "watcherName", newJString(watcherName))
  result = call_597074.call(path_597075, query_597076, nil, nil, nil)

var watcherStart* = Call_WatcherStart_597065(name: "watcherStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers/{watcherName}/start",
    validator: validate_WatcherStart_597066, base: "", url: url_WatcherStart_597067,
    schemes: {Scheme.Https})
type
  Call_WatcherStop_597077 = ref object of OpenApiRestCall_596458
proc url_WatcherStop_597079(protocol: Scheme; host: string; base: string;
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
  assert "watcherName" in path, "`watcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/watchers/"),
               (kind: VariableSegment, value: "watcherName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WatcherStop_597078(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: JString (required)
  ##              : The watcher name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597080 = path.getOrDefault("automationAccountName")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "automationAccountName", valid_597080
  var valid_597081 = path.getOrDefault("resourceGroupName")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "resourceGroupName", valid_597081
  var valid_597082 = path.getOrDefault("subscriptionId")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "subscriptionId", valid_597082
  var valid_597083 = path.getOrDefault("watcherName")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "watcherName", valid_597083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597084 = query.getOrDefault("api-version")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "api-version", valid_597084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597085: Call_WatcherStop_597077; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume the watcher identified by watcher name.
  ## 
  ## http://aka.ms/azureautomationsdk/watcheroperations
  let valid = call_597085.validator(path, query, header, formData, body)
  let scheme = call_597085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597085.url(scheme.get, call_597085.host, call_597085.base,
                         call_597085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597085, url, valid)

proc call*(call_597086: Call_WatcherStop_597077; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          watcherName: string): Recallable =
  ## watcherStop
  ## Resume the watcher identified by watcher name.
  ## http://aka.ms/azureautomationsdk/watcheroperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   watcherName: string (required)
  ##              : The watcher name.
  var path_597087 = newJObject()
  var query_597088 = newJObject()
  add(path_597087, "automationAccountName", newJString(automationAccountName))
  add(path_597087, "resourceGroupName", newJString(resourceGroupName))
  add(query_597088, "api-version", newJString(apiVersion))
  add(path_597087, "subscriptionId", newJString(subscriptionId))
  add(path_597087, "watcherName", newJString(watcherName))
  result = call_597086.call(path_597087, query_597088, nil, nil, nil)

var watcherStop* = Call_WatcherStop_597077(name: "watcherStop",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/watchers/{watcherName}/stop",
                                        validator: validate_WatcherStop_597078,
                                        base: "", url: url_WatcherStop_597079,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
