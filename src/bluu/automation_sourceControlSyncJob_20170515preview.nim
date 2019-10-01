
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
  macServiceName = "automation-sourceControlSyncJob"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SourceControlSyncJobListByAutomationAccount_596679 = ref object of OpenApiRestCall_596457
proc url_SourceControlSyncJobListByAutomationAccount_596681(protocol: Scheme;
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
               (kind: VariableSegment, value: "sourceControlName"),
               (kind: ConstantSegment, value: "/sourceControlSyncJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlSyncJobListByAutomationAccount_596680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of source control sync jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
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
  var valid_596844 = path.getOrDefault("sourceControlName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "sourceControlName", valid_596844
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

proc call*(call_596874: Call_SourceControlSyncJobListByAutomationAccount_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of source control sync jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_596874.validator(path, query, header, formData, body)
  let scheme = call_596874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596874.url(scheme.get, call_596874.host, call_596874.base,
                         call_596874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596874, url, valid)

proc call*(call_596945: Call_SourceControlSyncJobListByAutomationAccount_596679;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## sourceControlSyncJobListByAutomationAccount
  ## Retrieve a list of source control sync jobs.
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
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
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_596946 = newJObject()
  var query_596948 = newJObject()
  add(path_596946, "automationAccountName", newJString(automationAccountName))
  add(path_596946, "resourceGroupName", newJString(resourceGroupName))
  add(query_596948, "api-version", newJString(apiVersion))
  add(path_596946, "sourceControlName", newJString(sourceControlName))
  add(path_596946, "subscriptionId", newJString(subscriptionId))
  add(query_596948, "$filter", newJString(Filter))
  result = call_596945.call(path_596946, query_596948, nil, nil, nil)

var sourceControlSyncJobListByAutomationAccount* = Call_SourceControlSyncJobListByAutomationAccount_596679(
    name: "sourceControlSyncJobListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs",
    validator: validate_SourceControlSyncJobListByAutomationAccount_596680,
    base: "", url: url_SourceControlSyncJobListByAutomationAccount_596681,
    schemes: {Scheme.Https})
type
  Call_SourceControlSyncJobCreate_597000 = ref object of OpenApiRestCall_596457
proc url_SourceControlSyncJobCreate_597002(protocol: Scheme; host: string;
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
  assert "sourceControlSyncJobId" in path,
        "`sourceControlSyncJobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/sourceControls/"),
               (kind: VariableSegment, value: "sourceControlName"),
               (kind: ConstantSegment, value: "/sourceControlSyncJobs/"),
               (kind: VariableSegment, value: "sourceControlSyncJobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlSyncJobCreate_597001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the sync job for a source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
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
  ##   sourceControlSyncJobId: JString (required)
  ##                         : The source control sync job id.
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
  var valid_597031 = path.getOrDefault("sourceControlName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "sourceControlName", valid_597031
  var valid_597032 = path.getOrDefault("subscriptionId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "subscriptionId", valid_597032
  var valid_597033 = path.getOrDefault("sourceControlSyncJobId")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "sourceControlSyncJobId", valid_597033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597034 = query.getOrDefault("api-version")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "api-version", valid_597034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create source control sync job operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597036: Call_SourceControlSyncJobCreate_597000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the sync job for a source control.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_597036.validator(path, query, header, formData, body)
  let scheme = call_597036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597036.url(scheme.get, call_597036.host, call_597036.base,
                         call_597036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597036, url, valid)

proc call*(call_597037: Call_SourceControlSyncJobCreate_597000;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          sourceControlSyncJobId: string; parameters: JsonNode): Recallable =
  ## sourceControlSyncJobCreate
  ## Creates the sync job for a source control.
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
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
  ##   sourceControlSyncJobId: string (required)
  ##                         : The source control sync job id.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create source control sync job operation.
  var path_597038 = newJObject()
  var query_597039 = newJObject()
  var body_597040 = newJObject()
  add(path_597038, "automationAccountName", newJString(automationAccountName))
  add(path_597038, "resourceGroupName", newJString(resourceGroupName))
  add(query_597039, "api-version", newJString(apiVersion))
  add(path_597038, "sourceControlName", newJString(sourceControlName))
  add(path_597038, "subscriptionId", newJString(subscriptionId))
  add(path_597038, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  if parameters != nil:
    body_597040 = parameters
  result = call_597037.call(path_597038, query_597039, nil, nil, body_597040)

var sourceControlSyncJobCreate* = Call_SourceControlSyncJobCreate_597000(
    name: "sourceControlSyncJobCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}",
    validator: validate_SourceControlSyncJobCreate_597001, base: "",
    url: url_SourceControlSyncJobCreate_597002, schemes: {Scheme.Https})
type
  Call_SourceControlSyncJobGet_596987 = ref object of OpenApiRestCall_596457
proc url_SourceControlSyncJobGet_596989(protocol: Scheme; host: string; base: string;
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
  assert "sourceControlName" in path,
        "`sourceControlName` is a required path parameter"
  assert "sourceControlSyncJobId" in path,
        "`sourceControlSyncJobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/sourceControls/"),
               (kind: VariableSegment, value: "sourceControlName"),
               (kind: ConstantSegment, value: "/sourceControlSyncJobs/"),
               (kind: VariableSegment, value: "sourceControlSyncJobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlSyncJobGet_596988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the source control sync job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
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
  ##   sourceControlSyncJobId: JString (required)
  ##                         : The source control sync job id.
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
  var valid_596992 = path.getOrDefault("sourceControlName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "sourceControlName", valid_596992
  var valid_596993 = path.getOrDefault("subscriptionId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "subscriptionId", valid_596993
  var valid_596994 = path.getOrDefault("sourceControlSyncJobId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "sourceControlSyncJobId", valid_596994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596996: Call_SourceControlSyncJobGet_596987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the source control sync job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_596996.validator(path, query, header, formData, body)
  let scheme = call_596996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596996.url(scheme.get, call_596996.host, call_596996.base,
                         call_596996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596996, url, valid)

proc call*(call_596997: Call_SourceControlSyncJobGet_596987;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          sourceControlSyncJobId: string): Recallable =
  ## sourceControlSyncJobGet
  ## Retrieve the source control sync job identified by job id.
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
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
  ##   sourceControlSyncJobId: string (required)
  ##                         : The source control sync job id.
  var path_596998 = newJObject()
  var query_596999 = newJObject()
  add(path_596998, "automationAccountName", newJString(automationAccountName))
  add(path_596998, "resourceGroupName", newJString(resourceGroupName))
  add(query_596999, "api-version", newJString(apiVersion))
  add(path_596998, "sourceControlName", newJString(sourceControlName))
  add(path_596998, "subscriptionId", newJString(subscriptionId))
  add(path_596998, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  result = call_596997.call(path_596998, query_596999, nil, nil, nil)

var sourceControlSyncJobGet* = Call_SourceControlSyncJobGet_596987(
    name: "sourceControlSyncJobGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}",
    validator: validate_SourceControlSyncJobGet_596988, base: "",
    url: url_SourceControlSyncJobGet_596989, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
