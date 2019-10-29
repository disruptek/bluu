
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "automation-sourceControlSyncJobStreams"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SourceControlSyncJobStreamsListBySyncJob_563778 = ref object of OpenApiRestCall_563556
proc url_SourceControlSyncJobStreamsListBySyncJob_563780(protocol: Scheme;
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

proc validate_SourceControlSyncJobStreamsListBySyncJob_563779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of sync job streams identified by sync job id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   sourceControlName: JString (required)
  ##                    : The source control name.
  ##   sourceControlSyncJobId: JString (required)
  ##                         : The source control sync job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_563943 = path.getOrDefault("automationAccountName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "automationAccountName", valid_563943
  var valid_563944 = path.getOrDefault("sourceControlName")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "sourceControlName", valid_563944
  var valid_563945 = path.getOrDefault("sourceControlSyncJobId")
  valid_563945 = validateParameter(valid_563945, JString, required = true,
                                 default = nil)
  if valid_563945 != nil:
    section.add "sourceControlSyncJobId", valid_563945
  var valid_563946 = path.getOrDefault("subscriptionId")
  valid_563946 = validateParameter(valid_563946, JString, required = true,
                                 default = nil)
  if valid_563946 != nil:
    section.add "subscriptionId", valid_563946
  var valid_563947 = path.getOrDefault("resourceGroupName")
  valid_563947 = validateParameter(valid_563947, JString, required = true,
                                 default = nil)
  if valid_563947 != nil:
    section.add "resourceGroupName", valid_563947
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563948 = query.getOrDefault("api-version")
  valid_563948 = validateParameter(valid_563948, JString, required = true,
                                 default = nil)
  if valid_563948 != nil:
    section.add "api-version", valid_563948
  var valid_563949 = query.getOrDefault("$filter")
  valid_563949 = validateParameter(valid_563949, JString, required = false,
                                 default = nil)
  if valid_563949 != nil:
    section.add "$filter", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563976: Call_SourceControlSyncJobStreamsListBySyncJob_563778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of sync job streams identified by sync job id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_563976.validator(path, query, header, formData, body)
  let scheme = call_563976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563976.url(scheme.get, call_563976.host, call_563976.base,
                         call_563976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563976, url, valid)

proc call*(call_564047: Call_SourceControlSyncJobStreamsListBySyncJob_563778;
          apiVersion: string; automationAccountName: string;
          sourceControlName: string; sourceControlSyncJobId: string;
          subscriptionId: string; resourceGroupName: string; Filter: string = ""): Recallable =
  ## sourceControlSyncJobStreamsListBySyncJob
  ## Retrieve a list of sync job streams identified by sync job id.
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   sourceControlName: string (required)
  ##                    : The source control name.
  ##   sourceControlSyncJobId: string (required)
  ##                         : The source control sync job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564048 = newJObject()
  var query_564050 = newJObject()
  add(query_564050, "api-version", newJString(apiVersion))
  add(path_564048, "automationAccountName", newJString(automationAccountName))
  add(path_564048, "sourceControlName", newJString(sourceControlName))
  add(path_564048, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  add(path_564048, "subscriptionId", newJString(subscriptionId))
  add(path_564048, "resourceGroupName", newJString(resourceGroupName))
  add(query_564050, "$filter", newJString(Filter))
  result = call_564047.call(path_564048, query_564050, nil, nil, nil)

var sourceControlSyncJobStreamsListBySyncJob* = Call_SourceControlSyncJobStreamsListBySyncJob_563778(
    name: "sourceControlSyncJobStreamsListBySyncJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}/streams",
    validator: validate_SourceControlSyncJobStreamsListBySyncJob_563779, base: "",
    url: url_SourceControlSyncJobStreamsListBySyncJob_563780,
    schemes: {Scheme.Https})
type
  Call_SourceControlSyncJobStreamsGet_564089 = ref object of OpenApiRestCall_563556
proc url_SourceControlSyncJobStreamsGet_564091(protocol: Scheme; host: string;
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

proc validate_SourceControlSyncJobStreamsGet_564090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a sync job stream identified by stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   sourceControlName: JString (required)
  ##                    : The source control name.
  ##   streamId: JString (required)
  ##           : The id of the sync job stream.
  ##   sourceControlSyncJobId: JString (required)
  ##                         : The source control sync job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564092 = path.getOrDefault("automationAccountName")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "automationAccountName", valid_564092
  var valid_564093 = path.getOrDefault("sourceControlName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "sourceControlName", valid_564093
  var valid_564094 = path.getOrDefault("streamId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "streamId", valid_564094
  var valid_564095 = path.getOrDefault("sourceControlSyncJobId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "sourceControlSyncJobId", valid_564095
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("resourceGroupName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "resourceGroupName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_SourceControlSyncJobStreamsGet_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a sync job stream identified by stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_SourceControlSyncJobStreamsGet_564089;
          apiVersion: string; automationAccountName: string;
          sourceControlName: string; streamId: string;
          sourceControlSyncJobId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## sourceControlSyncJobStreamsGet
  ## Retrieve a sync job stream identified by stream id.
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   sourceControlName: string (required)
  ##                    : The source control name.
  ##   streamId: string (required)
  ##           : The id of the sync job stream.
  ##   sourceControlSyncJobId: string (required)
  ##                         : The source control sync job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "automationAccountName", newJString(automationAccountName))
  add(path_564101, "sourceControlName", newJString(sourceControlName))
  add(path_564101, "streamId", newJString(streamId))
  add(path_564101, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "resourceGroupName", newJString(resourceGroupName))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var sourceControlSyncJobStreamsGet* = Call_SourceControlSyncJobStreamsGet_564089(
    name: "sourceControlSyncJobStreamsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}/streams/{streamId}",
    validator: validate_SourceControlSyncJobStreamsGet_564090, base: "",
    url: url_SourceControlSyncJobStreamsGet_564091, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
