
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
  macServiceName = "automation-module"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ModuleListByAutomationAccount_596680 = ref object of OpenApiRestCall_596458
proc url_ModuleListByAutomationAccount_596682(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/modules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModuleListByAutomationAccount_596681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of modules.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
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

proc call*(call_596872: Call_ModuleListByAutomationAccount_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of modules.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  let valid = call_596872.validator(path, query, header, formData, body)
  let scheme = call_596872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596872.url(scheme.get, call_596872.host, call_596872.base,
                         call_596872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596872, url, valid)

proc call*(call_596943: Call_ModuleListByAutomationAccount_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## moduleListByAutomationAccount
  ## Retrieve a list of modules.
  ## http://aka.ms/azureautomationsdk/moduleoperations
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

var moduleListByAutomationAccount* = Call_ModuleListByAutomationAccount_596680(
    name: "moduleListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules",
    validator: validate_ModuleListByAutomationAccount_596681, base: "",
    url: url_ModuleListByAutomationAccount_596682, schemes: {Scheme.Https})
type
  Call_ModuleCreateOrUpdate_596997 = ref object of OpenApiRestCall_596458
proc url_ModuleCreateOrUpdate_596999(protocol: Scheme; host: string; base: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModuleCreateOrUpdate_596998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or Update the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The name of module.
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
  var valid_597028 = path.getOrDefault("subscriptionId")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "subscriptionId", valid_597028
  var valid_597029 = path.getOrDefault("moduleName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "moduleName", valid_597029
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
  ##             : The create or update parameters for module.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597032: Call_ModuleCreateOrUpdate_596997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or Update the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  let valid = call_597032.validator(path, query, header, formData, body)
  let scheme = call_597032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597032.url(scheme.get, call_597032.host, call_597032.base,
                         call_597032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597032, url, valid)

proc call*(call_597033: Call_ModuleCreateOrUpdate_596997;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; moduleName: string;
          parameters: JsonNode): Recallable =
  ## moduleCreateOrUpdate
  ## Create or Update the module identified by module name.
  ## http://aka.ms/azureautomationsdk/moduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The name of module.
  ##   parameters: JObject (required)
  ##             : The create or update parameters for module.
  var path_597034 = newJObject()
  var query_597035 = newJObject()
  var body_597036 = newJObject()
  add(path_597034, "automationAccountName", newJString(automationAccountName))
  add(path_597034, "resourceGroupName", newJString(resourceGroupName))
  add(query_597035, "api-version", newJString(apiVersion))
  add(path_597034, "subscriptionId", newJString(subscriptionId))
  add(path_597034, "moduleName", newJString(moduleName))
  if parameters != nil:
    body_597036 = parameters
  result = call_597033.call(path_597034, query_597035, nil, nil, body_597036)

var moduleCreateOrUpdate* = Call_ModuleCreateOrUpdate_596997(
    name: "moduleCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}",
    validator: validate_ModuleCreateOrUpdate_596998, base: "",
    url: url_ModuleCreateOrUpdate_596999, schemes: {Scheme.Https})
type
  Call_ModuleGet_596985 = ref object of OpenApiRestCall_596458
proc url_ModuleGet_596987(protocol: Scheme; host: string; base: string; route: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModuleGet_596986(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The module name.
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
  var valid_596990 = path.getOrDefault("subscriptionId")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "subscriptionId", valid_596990
  var valid_596991 = path.getOrDefault("moduleName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "moduleName", valid_596991
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

proc call*(call_596993: Call_ModuleGet_596985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  let valid = call_596993.validator(path, query, header, formData, body)
  let scheme = call_596993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596993.url(scheme.get, call_596993.host, call_596993.base,
                         call_596993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596993, url, valid)

proc call*(call_596994: Call_ModuleGet_596985; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          moduleName: string): Recallable =
  ## moduleGet
  ## Retrieve the module identified by module name.
  ## http://aka.ms/azureautomationsdk/moduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The module name.
  var path_596995 = newJObject()
  var query_596996 = newJObject()
  add(path_596995, "automationAccountName", newJString(automationAccountName))
  add(path_596995, "resourceGroupName", newJString(resourceGroupName))
  add(query_596996, "api-version", newJString(apiVersion))
  add(path_596995, "subscriptionId", newJString(subscriptionId))
  add(path_596995, "moduleName", newJString(moduleName))
  result = call_596994.call(path_596995, query_596996, nil, nil, nil)

var moduleGet* = Call_ModuleGet_596985(name: "moduleGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}",
                                    validator: validate_ModuleGet_596986,
                                    base: "", url: url_ModuleGet_596987,
                                    schemes: {Scheme.Https})
type
  Call_ModuleUpdate_597049 = ref object of OpenApiRestCall_596458
proc url_ModuleUpdate_597051(protocol: Scheme; host: string; base: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModuleUpdate_597050(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The name of module.
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
  var valid_597054 = path.getOrDefault("subscriptionId")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "subscriptionId", valid_597054
  var valid_597055 = path.getOrDefault("moduleName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "moduleName", valid_597055
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
  ##             : The update parameters for module.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597058: Call_ModuleUpdate_597049; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  let valid = call_597058.validator(path, query, header, formData, body)
  let scheme = call_597058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597058.url(scheme.get, call_597058.host, call_597058.base,
                         call_597058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597058, url, valid)

proc call*(call_597059: Call_ModuleUpdate_597049; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          moduleName: string; parameters: JsonNode): Recallable =
  ## moduleUpdate
  ## Update the module identified by module name.
  ## http://aka.ms/azureautomationsdk/moduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The name of module.
  ##   parameters: JObject (required)
  ##             : The update parameters for module.
  var path_597060 = newJObject()
  var query_597061 = newJObject()
  var body_597062 = newJObject()
  add(path_597060, "automationAccountName", newJString(automationAccountName))
  add(path_597060, "resourceGroupName", newJString(resourceGroupName))
  add(query_597061, "api-version", newJString(apiVersion))
  add(path_597060, "subscriptionId", newJString(subscriptionId))
  add(path_597060, "moduleName", newJString(moduleName))
  if parameters != nil:
    body_597062 = parameters
  result = call_597059.call(path_597060, query_597061, nil, nil, body_597062)

var moduleUpdate* = Call_ModuleUpdate_597049(name: "moduleUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}",
    validator: validate_ModuleUpdate_597050, base: "", url: url_ModuleUpdate_597051,
    schemes: {Scheme.Https})
type
  Call_ModuleDelete_597037 = ref object of OpenApiRestCall_596458
proc url_ModuleDelete_597039(protocol: Scheme; host: string; base: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModuleDelete_597038(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the module by name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The module name.
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
  var valid_597043 = path.getOrDefault("moduleName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "moduleName", valid_597043
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

proc call*(call_597045: Call_ModuleDelete_597037; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the module by name.
  ## 
  ## http://aka.ms/azureautomationsdk/moduleoperations
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_ModuleDelete_597037; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          moduleName: string): Recallable =
  ## moduleDelete
  ## Delete the module by name.
  ## http://aka.ms/azureautomationsdk/moduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The module name.
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  add(path_597047, "automationAccountName", newJString(automationAccountName))
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  add(path_597047, "moduleName", newJString(moduleName))
  result = call_597046.call(path_597047, query_597048, nil, nil, nil)

var moduleDelete* = Call_ModuleDelete_597037(name: "moduleDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}",
    validator: validate_ModuleDelete_597038, base: "", url: url_ModuleDelete_597039,
    schemes: {Scheme.Https})
type
  Call_ActivityListByModule_597063 = ref object of OpenApiRestCall_596458
proc url_ActivityListByModule_597065(protocol: Scheme; host: string; base: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName"),
               (kind: ConstantSegment, value: "/activities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivityListByModule_597064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of activities in the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/activityoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The name of module.
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
  var valid_597068 = path.getOrDefault("subscriptionId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "subscriptionId", valid_597068
  var valid_597069 = path.getOrDefault("moduleName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "moduleName", valid_597069
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

proc call*(call_597071: Call_ActivityListByModule_597063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of activities in the module identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/activityoperations
  let valid = call_597071.validator(path, query, header, formData, body)
  let scheme = call_597071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597071.url(scheme.get, call_597071.host, call_597071.base,
                         call_597071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597071, url, valid)

proc call*(call_597072: Call_ActivityListByModule_597063;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; moduleName: string): Recallable =
  ## activityListByModule
  ## Retrieve a list of activities in the module identified by module name.
  ## http://aka.ms/azureautomationsdk/activityoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The name of module.
  var path_597073 = newJObject()
  var query_597074 = newJObject()
  add(path_597073, "automationAccountName", newJString(automationAccountName))
  add(path_597073, "resourceGroupName", newJString(resourceGroupName))
  add(query_597074, "api-version", newJString(apiVersion))
  add(path_597073, "subscriptionId", newJString(subscriptionId))
  add(path_597073, "moduleName", newJString(moduleName))
  result = call_597072.call(path_597073, query_597074, nil, nil, nil)

var activityListByModule* = Call_ActivityListByModule_597063(
    name: "activityListByModule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}/activities",
    validator: validate_ActivityListByModule_597064, base: "",
    url: url_ActivityListByModule_597065, schemes: {Scheme.Https})
type
  Call_ActivityGet_597075 = ref object of OpenApiRestCall_596458
proc url_ActivityGet_597077(protocol: Scheme; host: string; base: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  assert "activityName" in path, "`activityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName"),
               (kind: ConstantSegment, value: "/activities/"),
               (kind: VariableSegment, value: "activityName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivityGet_597076(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the activity in the module identified by module name and activity name.
  ## 
  ## http://aka.ms/azureautomationsdk/activityoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   activityName: JString (required)
  ##               : The name of activity.
  ##   moduleName: JString (required)
  ##             : The name of module.
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
  var valid_597080 = path.getOrDefault("subscriptionId")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "subscriptionId", valid_597080
  var valid_597081 = path.getOrDefault("activityName")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "activityName", valid_597081
  var valid_597082 = path.getOrDefault("moduleName")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "moduleName", valid_597082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597083 = query.getOrDefault("api-version")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "api-version", valid_597083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597084: Call_ActivityGet_597075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the activity in the module identified by module name and activity name.
  ## 
  ## http://aka.ms/azureautomationsdk/activityoperations
  let valid = call_597084.validator(path, query, header, formData, body)
  let scheme = call_597084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597084.url(scheme.get, call_597084.host, call_597084.base,
                         call_597084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597084, url, valid)

proc call*(call_597085: Call_ActivityGet_597075; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          activityName: string; moduleName: string): Recallable =
  ## activityGet
  ## Retrieve the activity in the module identified by module name and activity name.
  ## http://aka.ms/azureautomationsdk/activityoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   activityName: string (required)
  ##               : The name of activity.
  ##   moduleName: string (required)
  ##             : The name of module.
  var path_597086 = newJObject()
  var query_597087 = newJObject()
  add(path_597086, "automationAccountName", newJString(automationAccountName))
  add(path_597086, "resourceGroupName", newJString(resourceGroupName))
  add(query_597087, "api-version", newJString(apiVersion))
  add(path_597086, "subscriptionId", newJString(subscriptionId))
  add(path_597086, "activityName", newJString(activityName))
  add(path_597086, "moduleName", newJString(moduleName))
  result = call_597085.call(path_597086, query_597087, nil, nil, nil)

var activityGet* = Call_ActivityGet_597075(name: "activityGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}/activities/{activityName}",
                                        validator: validate_ActivityGet_597076,
                                        base: "", url: url_ActivityGet_597077,
                                        schemes: {Scheme.Https})
type
  Call_ObjectDataTypesListFieldsByModuleAndType_597088 = ref object of OpenApiRestCall_596458
proc url_ObjectDataTypesListFieldsByModuleAndType_597090(protocol: Scheme;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  assert "typeName" in path, "`typeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName"),
               (kind: ConstantSegment, value: "/objectDataTypes/"),
               (kind: VariableSegment, value: "typeName"),
               (kind: ConstantSegment, value: "/fields")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ObjectDataTypesListFieldsByModuleAndType_597089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of fields of a given type identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/objectdatatypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   typeName: JString (required)
  ##           : The name of type.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The name of module.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597091 = path.getOrDefault("automationAccountName")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "automationAccountName", valid_597091
  var valid_597092 = path.getOrDefault("resourceGroupName")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "resourceGroupName", valid_597092
  var valid_597093 = path.getOrDefault("typeName")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "typeName", valid_597093
  var valid_597094 = path.getOrDefault("subscriptionId")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "subscriptionId", valid_597094
  var valid_597095 = path.getOrDefault("moduleName")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "moduleName", valid_597095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597096 = query.getOrDefault("api-version")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "api-version", valid_597096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597097: Call_ObjectDataTypesListFieldsByModuleAndType_597088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of fields of a given type identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/objectdatatypeoperations
  let valid = call_597097.validator(path, query, header, formData, body)
  let scheme = call_597097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597097.url(scheme.get, call_597097.host, call_597097.base,
                         call_597097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597097, url, valid)

proc call*(call_597098: Call_ObjectDataTypesListFieldsByModuleAndType_597088;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; typeName: string; subscriptionId: string;
          moduleName: string): Recallable =
  ## objectDataTypesListFieldsByModuleAndType
  ## Retrieve a list of fields of a given type identified by module name.
  ## http://aka.ms/azureautomationsdk/objectdatatypeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   typeName: string (required)
  ##           : The name of type.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The name of module.
  var path_597099 = newJObject()
  var query_597100 = newJObject()
  add(path_597099, "automationAccountName", newJString(automationAccountName))
  add(path_597099, "resourceGroupName", newJString(resourceGroupName))
  add(query_597100, "api-version", newJString(apiVersion))
  add(path_597099, "typeName", newJString(typeName))
  add(path_597099, "subscriptionId", newJString(subscriptionId))
  add(path_597099, "moduleName", newJString(moduleName))
  result = call_597098.call(path_597099, query_597100, nil, nil, nil)

var objectDataTypesListFieldsByModuleAndType* = Call_ObjectDataTypesListFieldsByModuleAndType_597088(
    name: "objectDataTypesListFieldsByModuleAndType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}/objectDataTypes/{typeName}/fields",
    validator: validate_ObjectDataTypesListFieldsByModuleAndType_597089, base: "",
    url: url_ObjectDataTypesListFieldsByModuleAndType_597090,
    schemes: {Scheme.Https})
type
  Call_FieldsListByType_597101 = ref object of OpenApiRestCall_596458
proc url_FieldsListByType_597103(protocol: Scheme; host: string; base: string;
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
  assert "moduleName" in path, "`moduleName` is a required path parameter"
  assert "typeName" in path, "`typeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "moduleName"),
               (kind: ConstantSegment, value: "/types/"),
               (kind: VariableSegment, value: "typeName"),
               (kind: ConstantSegment, value: "/fields")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FieldsListByType_597102(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieve a list of fields of a given type identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/typefieldoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   typeName: JString (required)
  ##           : The name of type.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: JString (required)
  ##             : The name of module.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597104 = path.getOrDefault("automationAccountName")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "automationAccountName", valid_597104
  var valid_597105 = path.getOrDefault("resourceGroupName")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "resourceGroupName", valid_597105
  var valid_597106 = path.getOrDefault("typeName")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "typeName", valid_597106
  var valid_597107 = path.getOrDefault("subscriptionId")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = nil)
  if valid_597107 != nil:
    section.add "subscriptionId", valid_597107
  var valid_597108 = path.getOrDefault("moduleName")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "moduleName", valid_597108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597109 = query.getOrDefault("api-version")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "api-version", valid_597109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597110: Call_FieldsListByType_597101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of fields of a given type identified by module name.
  ## 
  ## http://aka.ms/azureautomationsdk/typefieldoperations
  let valid = call_597110.validator(path, query, header, formData, body)
  let scheme = call_597110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597110.url(scheme.get, call_597110.host, call_597110.base,
                         call_597110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597110, url, valid)

proc call*(call_597111: Call_FieldsListByType_597101;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; typeName: string; subscriptionId: string;
          moduleName: string): Recallable =
  ## fieldsListByType
  ## Retrieve a list of fields of a given type identified by module name.
  ## http://aka.ms/azureautomationsdk/typefieldoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   typeName: string (required)
  ##           : The name of type.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   moduleName: string (required)
  ##             : The name of module.
  var path_597112 = newJObject()
  var query_597113 = newJObject()
  add(path_597112, "automationAccountName", newJString(automationAccountName))
  add(path_597112, "resourceGroupName", newJString(resourceGroupName))
  add(query_597113, "api-version", newJString(apiVersion))
  add(path_597112, "typeName", newJString(typeName))
  add(path_597112, "subscriptionId", newJString(subscriptionId))
  add(path_597112, "moduleName", newJString(moduleName))
  result = call_597111.call(path_597112, query_597113, nil, nil, nil)

var fieldsListByType* = Call_FieldsListByType_597101(name: "fieldsListByType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/modules/{moduleName}/types/{typeName}/fields",
    validator: validate_FieldsListByType_597102, base: "",
    url: url_FieldsListByType_597103, schemes: {Scheme.Https})
type
  Call_ObjectDataTypesListFieldsByType_597114 = ref object of OpenApiRestCall_596458
proc url_ObjectDataTypesListFieldsByType_597116(protocol: Scheme; host: string;
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
  assert "typeName" in path, "`typeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/objectDataTypes/"),
               (kind: VariableSegment, value: "typeName"),
               (kind: ConstantSegment, value: "/fields")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ObjectDataTypesListFieldsByType_597115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of fields of a given type across all accessible modules.
  ## 
  ## http://aka.ms/azureautomationsdk/objectdatatypeoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   typeName: JString (required)
  ##           : The name of type.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597117 = path.getOrDefault("automationAccountName")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "automationAccountName", valid_597117
  var valid_597118 = path.getOrDefault("resourceGroupName")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = nil)
  if valid_597118 != nil:
    section.add "resourceGroupName", valid_597118
  var valid_597119 = path.getOrDefault("typeName")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "typeName", valid_597119
  var valid_597120 = path.getOrDefault("subscriptionId")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "subscriptionId", valid_597120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597121 = query.getOrDefault("api-version")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "api-version", valid_597121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597122: Call_ObjectDataTypesListFieldsByType_597114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of fields of a given type across all accessible modules.
  ## 
  ## http://aka.ms/azureautomationsdk/objectdatatypeoperations
  let valid = call_597122.validator(path, query, header, formData, body)
  let scheme = call_597122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597122.url(scheme.get, call_597122.host, call_597122.base,
                         call_597122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597122, url, valid)

proc call*(call_597123: Call_ObjectDataTypesListFieldsByType_597114;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; typeName: string; subscriptionId: string): Recallable =
  ## objectDataTypesListFieldsByType
  ## Retrieve a list of fields of a given type across all accessible modules.
  ## http://aka.ms/azureautomationsdk/objectdatatypeoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   typeName: string (required)
  ##           : The name of type.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597124 = newJObject()
  var query_597125 = newJObject()
  add(path_597124, "automationAccountName", newJString(automationAccountName))
  add(path_597124, "resourceGroupName", newJString(resourceGroupName))
  add(query_597125, "api-version", newJString(apiVersion))
  add(path_597124, "typeName", newJString(typeName))
  add(path_597124, "subscriptionId", newJString(subscriptionId))
  result = call_597123.call(path_597124, query_597125, nil, nil, nil)

var objectDataTypesListFieldsByType* = Call_ObjectDataTypesListFieldsByType_597114(
    name: "objectDataTypesListFieldsByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/objectDataTypes/{typeName}/fields",
    validator: validate_ObjectDataTypesListFieldsByType_597115, base: "",
    url: url_ObjectDataTypesListFieldsByType_597116, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
