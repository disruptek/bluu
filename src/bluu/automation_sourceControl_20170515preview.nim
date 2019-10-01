
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2017-05-15-preview
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
  macServiceName = "automation-sourceControl"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SourceControlListByAutomationAccount_596679 = ref object of OpenApiRestCall_596457
proc url_SourceControlListByAutomationAccount_596681(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/sourceControls")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlListByAutomationAccount_596680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of source controls.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
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

proc call*(call_596873: Call_SourceControlListByAutomationAccount_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of source controls.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  let valid = call_596873.validator(path, query, header, formData, body)
  let scheme = call_596873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596873.url(scheme.get, call_596873.host, call_596873.base,
                         call_596873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596873, url, valid)

proc call*(call_596944: Call_SourceControlListByAutomationAccount_596679;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## sourceControlListByAutomationAccount
  ## Retrieve a list of source controls.
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
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

var sourceControlListByAutomationAccount* = Call_SourceControlListByAutomationAccount_596679(
    name: "sourceControlListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls",
    validator: validate_SourceControlListByAutomationAccount_596680, base: "",
    url: url_SourceControlListByAutomationAccount_596681, schemes: {Scheme.Https})
type
  Call_SourceControlCreateOrUpdate_596998 = ref object of OpenApiRestCall_596457
proc url_SourceControlCreateOrUpdate_597000(protocol: Scheme; host: string;
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
  assert "sourceControlName" in path,
        "`sourceControlName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/sourceControls/"),
               (kind: VariableSegment, value: "sourceControlName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlCreateOrUpdate_596999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   sourceControlName: JString (required)
  ##                    : The source control name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597027 = path.getOrDefault("automationAccountName")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "automationAccountName", valid_597027
  var valid_597028 = path.getOrDefault("resourceGroupName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "resourceGroupName", valid_597028
  var valid_597029 = path.getOrDefault("sourceControlName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "sourceControlName", valid_597029
  var valid_597030 = path.getOrDefault("subscriptionId")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "subscriptionId", valid_597030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597031 = query.getOrDefault("api-version")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "api-version", valid_597031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create or update source control operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597033: Call_SourceControlCreateOrUpdate_596998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  let valid = call_597033.validator(path, query, header, formData, body)
  let scheme = call_597033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597033.url(scheme.get, call_597033.host, call_597033.base,
                         call_597033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597033, url, valid)

proc call*(call_597034: Call_SourceControlCreateOrUpdate_596998;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## sourceControlCreateOrUpdate
  ## Create a source control.
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   sourceControlName: string (required)
  ##                    : The source control name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create or update source control operation.
  var path_597035 = newJObject()
  var query_597036 = newJObject()
  var body_597037 = newJObject()
  add(path_597035, "automationAccountName", newJString(automationAccountName))
  add(path_597035, "resourceGroupName", newJString(resourceGroupName))
  add(query_597036, "api-version", newJString(apiVersion))
  add(path_597035, "sourceControlName", newJString(sourceControlName))
  add(path_597035, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597037 = parameters
  result = call_597034.call(path_597035, query_597036, nil, nil, body_597037)

var sourceControlCreateOrUpdate* = Call_SourceControlCreateOrUpdate_596998(
    name: "sourceControlCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}",
    validator: validate_SourceControlCreateOrUpdate_596999, base: "",
    url: url_SourceControlCreateOrUpdate_597000, schemes: {Scheme.Https})
type
  Call_SourceControlGet_596986 = ref object of OpenApiRestCall_596457
proc url_SourceControlGet_596988(protocol: Scheme; host: string; base: string;
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
  assert "sourceControlName" in path,
        "`sourceControlName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/sourceControls/"),
               (kind: VariableSegment, value: "sourceControlName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlGet_596987(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieve the source control identified by source control name.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   sourceControlName: JString (required)
  ##                    : The name of source control.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_596991 = path.getOrDefault("sourceControlName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "sourceControlName", valid_596991
  var valid_596992 = path.getOrDefault("subscriptionId")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "subscriptionId", valid_596992
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

proc call*(call_596994: Call_SourceControlGet_596986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the source control identified by source control name.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  let valid = call_596994.validator(path, query, header, formData, body)
  let scheme = call_596994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596994.url(scheme.get, call_596994.host, call_596994.base,
                         call_596994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596994, url, valid)

proc call*(call_596995: Call_SourceControlGet_596986;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string): Recallable =
  ## sourceControlGet
  ## Retrieve the source control identified by source control name.
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   sourceControlName: string (required)
  ##                    : The name of source control.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596996 = newJObject()
  var query_596997 = newJObject()
  add(path_596996, "automationAccountName", newJString(automationAccountName))
  add(path_596996, "resourceGroupName", newJString(resourceGroupName))
  add(query_596997, "api-version", newJString(apiVersion))
  add(path_596996, "sourceControlName", newJString(sourceControlName))
  add(path_596996, "subscriptionId", newJString(subscriptionId))
  result = call_596995.call(path_596996, query_596997, nil, nil, nil)

var sourceControlGet* = Call_SourceControlGet_596986(name: "sourceControlGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}",
    validator: validate_SourceControlGet_596987, base: "",
    url: url_SourceControlGet_596988, schemes: {Scheme.Https})
type
  Call_SourceControlUpdate_597050 = ref object of OpenApiRestCall_596457
proc url_SourceControlUpdate_597052(protocol: Scheme; host: string; base: string;
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
  assert "sourceControlName" in path,
        "`sourceControlName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/sourceControls/"),
               (kind: VariableSegment, value: "sourceControlName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlUpdate_597051(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update a source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   sourceControlName: JString (required)
  ##                    : The source control name.
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
  var valid_597055 = path.getOrDefault("sourceControlName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "sourceControlName", valid_597055
  var valid_597056 = path.getOrDefault("subscriptionId")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "subscriptionId", valid_597056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597057 = query.getOrDefault("api-version")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "api-version", valid_597057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the update source control operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597059: Call_SourceControlUpdate_597050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  let valid = call_597059.validator(path, query, header, formData, body)
  let scheme = call_597059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597059.url(scheme.get, call_597059.host, call_597059.base,
                         call_597059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597059, url, valid)

proc call*(call_597060: Call_SourceControlUpdate_597050;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## sourceControlUpdate
  ## Update a source control.
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   sourceControlName: string (required)
  ##                    : The source control name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the update source control operation.
  var path_597061 = newJObject()
  var query_597062 = newJObject()
  var body_597063 = newJObject()
  add(path_597061, "automationAccountName", newJString(automationAccountName))
  add(path_597061, "resourceGroupName", newJString(resourceGroupName))
  add(query_597062, "api-version", newJString(apiVersion))
  add(path_597061, "sourceControlName", newJString(sourceControlName))
  add(path_597061, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597063 = parameters
  result = call_597060.call(path_597061, query_597062, nil, nil, body_597063)

var sourceControlUpdate* = Call_SourceControlUpdate_597050(
    name: "sourceControlUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}",
    validator: validate_SourceControlUpdate_597051, base: "",
    url: url_SourceControlUpdate_597052, schemes: {Scheme.Https})
type
  Call_SourceControlDelete_597038 = ref object of OpenApiRestCall_596457
proc url_SourceControlDelete_597040(protocol: Scheme; host: string; base: string;
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
  assert "sourceControlName" in path,
        "`sourceControlName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/sourceControls/"),
               (kind: VariableSegment, value: "sourceControlName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlDelete_597039(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete the source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   sourceControlName: JString (required)
  ##                    : The name of source control.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597041 = path.getOrDefault("automationAccountName")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "automationAccountName", valid_597041
  var valid_597042 = path.getOrDefault("resourceGroupName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "resourceGroupName", valid_597042
  var valid_597043 = path.getOrDefault("sourceControlName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "sourceControlName", valid_597043
  var valid_597044 = path.getOrDefault("subscriptionId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "subscriptionId", valid_597044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597045 = query.getOrDefault("api-version")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "api-version", valid_597045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597046: Call_SourceControlDelete_597038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  let valid = call_597046.validator(path, query, header, formData, body)
  let scheme = call_597046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597046.url(scheme.get, call_597046.host, call_597046.base,
                         call_597046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597046, url, valid)

proc call*(call_597047: Call_SourceControlDelete_597038;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string): Recallable =
  ## sourceControlDelete
  ## Delete the source control.
  ## http://aka.ms/azureautomationsdk/sourcecontroloperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   sourceControlName: string (required)
  ##                    : The name of source control.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597048 = newJObject()
  var query_597049 = newJObject()
  add(path_597048, "automationAccountName", newJString(automationAccountName))
  add(path_597048, "resourceGroupName", newJString(resourceGroupName))
  add(query_597049, "api-version", newJString(apiVersion))
  add(path_597048, "sourceControlName", newJString(sourceControlName))
  add(path_597048, "subscriptionId", newJString(subscriptionId))
  result = call_597047.call(path_597048, query_597049, nil, nil, nil)

var sourceControlDelete* = Call_SourceControlDelete_597038(
    name: "sourceControlDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}",
    validator: validate_SourceControlDelete_597039, base: "",
    url: url_SourceControlDelete_597040, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
