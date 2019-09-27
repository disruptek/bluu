
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_SourceControlSyncJobStreamsListBySyncJob_593647 = ref object of OpenApiRestCall_593425
proc url_SourceControlSyncJobStreamsListBySyncJob_593649(protocol: Scheme;
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

proc validate_SourceControlSyncJobStreamsListBySyncJob_593648(path: JsonNode;
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
  var valid_593810 = path.getOrDefault("automationAccountName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "automationAccountName", valid_593810
  var valid_593811 = path.getOrDefault("resourceGroupName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "resourceGroupName", valid_593811
  var valid_593812 = path.getOrDefault("sourceControlName")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "sourceControlName", valid_593812
  var valid_593813 = path.getOrDefault("subscriptionId")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "subscriptionId", valid_593813
  var valid_593814 = path.getOrDefault("sourceControlSyncJobId")
  valid_593814 = validateParameter(valid_593814, JString, required = true,
                                 default = nil)
  if valid_593814 != nil:
    section.add "sourceControlSyncJobId", valid_593814
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593815 = query.getOrDefault("api-version")
  valid_593815 = validateParameter(valid_593815, JString, required = true,
                                 default = nil)
  if valid_593815 != nil:
    section.add "api-version", valid_593815
  var valid_593816 = query.getOrDefault("$filter")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "$filter", valid_593816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_SourceControlSyncJobStreamsListBySyncJob_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of sync job streams identified by sync job id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_SourceControlSyncJobStreamsListBySyncJob_593647;
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
  var path_593915 = newJObject()
  var query_593917 = newJObject()
  add(path_593915, "automationAccountName", newJString(automationAccountName))
  add(path_593915, "resourceGroupName", newJString(resourceGroupName))
  add(query_593917, "api-version", newJString(apiVersion))
  add(path_593915, "sourceControlName", newJString(sourceControlName))
  add(path_593915, "subscriptionId", newJString(subscriptionId))
  add(path_593915, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  add(query_593917, "$filter", newJString(Filter))
  result = call_593914.call(path_593915, query_593917, nil, nil, nil)

var sourceControlSyncJobStreamsListBySyncJob* = Call_SourceControlSyncJobStreamsListBySyncJob_593647(
    name: "sourceControlSyncJobStreamsListBySyncJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}/streams",
    validator: validate_SourceControlSyncJobStreamsListBySyncJob_593648, base: "",
    url: url_SourceControlSyncJobStreamsListBySyncJob_593649,
    schemes: {Scheme.Https})
type
  Call_SourceControlSyncJobStreamsGet_593956 = ref object of OpenApiRestCall_593425
proc url_SourceControlSyncJobStreamsGet_593958(protocol: Scheme; host: string;
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

proc validate_SourceControlSyncJobStreamsGet_593957(path: JsonNode;
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
  var valid_593959 = path.getOrDefault("automationAccountName")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "automationAccountName", valid_593959
  var valid_593960 = path.getOrDefault("resourceGroupName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "resourceGroupName", valid_593960
  var valid_593961 = path.getOrDefault("sourceControlName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "sourceControlName", valid_593961
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  var valid_593963 = path.getOrDefault("sourceControlSyncJobId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "sourceControlSyncJobId", valid_593963
  var valid_593964 = path.getOrDefault("streamId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "streamId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_SourceControlSyncJobStreamsGet_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a sync job stream identified by stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/sourcecontrolsyncjoboperations
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_SourceControlSyncJobStreamsGet_593956;
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
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "automationAccountName", newJString(automationAccountName))
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "sourceControlName", newJString(sourceControlName))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  add(path_593968, "sourceControlSyncJobId", newJString(sourceControlSyncJobId))
  add(path_593968, "streamId", newJString(streamId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var sourceControlSyncJobStreamsGet* = Call_SourceControlSyncJobStreamsGet_593956(
    name: "sourceControlSyncJobStreamsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/sourceControls/{sourceControlName}/sourceControlSyncJobs/{sourceControlSyncJobId}/streams/{streamId}",
    validator: validate_SourceControlSyncJobStreamsGet_593957, base: "",
    url: url_SourceControlSyncJobStreamsGet_593958, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
