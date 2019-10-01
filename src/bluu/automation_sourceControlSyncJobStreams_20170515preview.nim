
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
  macServiceName = "automation-sourceControlSyncJobStreams"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SourceControlSyncJobStreamsListBySyncJob_596680 = ref object of OpenApiRestCall_596458
proc url_SourceControlSyncJobStreamsListBySyncJob_596682(protocol: Scheme;
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
               (kind: VariableSegment, value: "sourceControlSyncJobId"),
               (kind: ConstantSegment, value: "/streams")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlSyncJobStreamsListBySyncJob_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of sync job streams identified by sync job id.
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
  var valid_596845 = path.getOrDefault("sourceControlName")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "sourceControlName", valid_596845
  var valid_596846 = path.getOrDefault("subscriptionId")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "subscriptionId", valid_596846
  var valid_596847 = path.getOrDefault("sourceControlSyncJobId")
  valid_596847 = validateParameter(valid_596847, JString, required = true,
                                 default = nil)
  if valid_596847 != nil:
    section.add "sourceControlSyncJobId", valid_596847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596848 = query.getOrDefault("api-version")
  valid_596848 = validateParameter(valid_596848, JString, required = true,
                                 default = nil)
  if valid_596848 != nil:
    section.add "api-version", valid_596848
  var valid_596849 = query.getOrDefault("$filter")
  valid_596849 = validateParameter(valid_596849, JString, required = false,
                                 default = nil)
  if valid_596849 != nil:
    section.add "$filter", valid_596849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596876: Call_SourceControlSyncJobStreamsListBySyncJob_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of sync job streams identified by sync job id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_596876.validator(path, query, header, formData, body)
  let scheme = call_596876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596876.url(scheme.get, call_596876.host, call_596876.base,
                         call_596876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596876, url, valid)

proc call*(call_596947: Call_SourceControlSyncJobStreamsListBySyncJob_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          sourceControlSyncJobId: string; Filter: string = ""): Recallable =
  ## sourceControlSyncJobStreamsListBySyncJob
  ## Retrieve a list of sync job streams identified by sync job id.
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
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_596948 = newJObject()
  var query_596950 = newJObject()
  add(path_596948, "automationAccountName", newJString(automationAccountName))
  add(path_596948, "resourceGroupName", newJString(resourceGroupName))
  add(query_596950, "api-version", newJString(apiVersion))
  add(path_596948, "sourceControlName", newJString(sourceControlName))
  add(path_596948, "subscriptionId", newJString(subscriptionId))
  add(path_596948, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  add(query_596950, "$filter", newJString(Filter))
  result = call_596947.call(path_596948, query_596950, nil, nil, nil)

var sourceControlSyncJobStreamsListBySyncJob* = Call_SourceControlSyncJobStreamsListBySyncJob_596680(
    name: "sourceControlSyncJobStreamsListBySyncJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}/streams",
    validator: validate_SourceControlSyncJobStreamsListBySyncJob_596681, base: "",
    url: url_SourceControlSyncJobStreamsListBySyncJob_596682,
    schemes: {Scheme.Https})
type
  Call_SourceControlSyncJobStreamsGet_596989 = ref object of OpenApiRestCall_596458
proc url_SourceControlSyncJobStreamsGet_596991(protocol: Scheme; host: string;
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
  assert "streamId" in path, "`streamId` is a required path parameter"
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
               (kind: VariableSegment, value: "sourceControlSyncJobId"),
               (kind: ConstantSegment, value: "/streams/"),
               (kind: VariableSegment, value: "streamId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SourceControlSyncJobStreamsGet_596990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a sync job stream identified by stream id.
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
  ##   streamId: JString (required)
  ##           : The id of the sync job stream.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596992 = path.getOrDefault("automationAccountName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "automationAccountName", valid_596992
  var valid_596993 = path.getOrDefault("resourceGroupName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "resourceGroupName", valid_596993
  var valid_596994 = path.getOrDefault("sourceControlName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "sourceControlName", valid_596994
  var valid_596995 = path.getOrDefault("subscriptionId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "subscriptionId", valid_596995
  var valid_596996 = path.getOrDefault("sourceControlSyncJobId")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "sourceControlSyncJobId", valid_596996
  var valid_596997 = path.getOrDefault("streamId")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "streamId", valid_596997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596998 = query.getOrDefault("api-version")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "api-version", valid_596998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596999: Call_SourceControlSyncJobStreamsGet_596989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a sync job stream identified by stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_SourceControlSyncJobStreamsGet_596989;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; sourceControlName: string; subscriptionId: string;
          sourceControlSyncJobId: string; streamId: string): Recallable =
  ## sourceControlSyncJobStreamsGet
  ## Retrieve a sync job stream identified by stream id.
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
  ##   streamId: string (required)
  ##           : The id of the sync job stream.
  var path_597001 = newJObject()
  var query_597002 = newJObject()
  add(path_597001, "automationAccountName", newJString(automationAccountName))
  add(path_597001, "resourceGroupName", newJString(resourceGroupName))
  add(query_597002, "api-version", newJString(apiVersion))
  add(path_597001, "sourceControlName", newJString(sourceControlName))
  add(path_597001, "subscriptionId", newJString(subscriptionId))
  add(path_597001, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  add(path_597001, "streamId", newJString(streamId))
  result = call_597000.call(path_597001, query_597002, nil, nil, nil)

var sourceControlSyncJobStreamsGet* = Call_SourceControlSyncJobStreamsGet_596989(
    name: "sourceControlSyncJobStreamsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}/streams/{streamId}",
    validator: validate_SourceControlSyncJobStreamsGet_596990, base: "",
    url: url_SourceControlSyncJobStreamsGet_596991, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
