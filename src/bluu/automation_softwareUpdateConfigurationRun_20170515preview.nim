
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Update Management
## version: 2017-05-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs for managing software update configurations.
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
  macServiceName = "automation-softwareUpdateConfigurationRun"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwareUpdateConfigurationRunsList_593647 = ref object of OpenApiRestCall_593425
proc url_SoftwareUpdateConfigurationRunsList_593649(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurationRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationRunsList_593648(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return list of software update configuration runs
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
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
  var valid_593812 = path.getOrDefault("subscriptionId")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "subscriptionId", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JString
  ##       : Maximum number of entries returned in the results collection
  ##   $skip: JString
  ##        : Number of entries you skip before returning results
  ##   $filter: JString
  ##          : The filter to apply on the operation. You can use the following filters: 'properties/osType', 'properties/status', 'properties/startTime', and 'properties/softwareUpdateConfiguration/name'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  var valid_593814 = query.getOrDefault("$top")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "$top", valid_593814
  var valid_593815 = query.getOrDefault("$skip")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "$skip", valid_593815
  var valid_593816 = query.getOrDefault("$filter")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "$filter", valid_593816
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593817 = header.getOrDefault("clientRequestId")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "clientRequestId", valid_593817
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_SoftwareUpdateConfigurationRunsList_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Return list of software update configuration runs
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_SoftwareUpdateConfigurationRunsList_593647;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: string = "";
          Skip: string = ""; Filter: string = ""): Recallable =
  ## softwareUpdateConfigurationRunsList
  ## Return list of software update configuration runs
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: string
  ##      : Maximum number of entries returned in the results collection
  ##   Skip: string
  ##       : Number of entries you skip before returning results
  ##   Filter: string
  ##         : The filter to apply on the operation. You can use the following filters: 'properties/osType', 'properties/status', 'properties/startTime', and 'properties/softwareUpdateConfiguration/name'
  var path_593916 = newJObject()
  var query_593918 = newJObject()
  add(path_593916, "automationAccountName", newJString(automationAccountName))
  add(path_593916, "resourceGroupName", newJString(resourceGroupName))
  add(query_593918, "api-version", newJString(apiVersion))
  add(path_593916, "subscriptionId", newJString(subscriptionId))
  add(query_593918, "$top", newJString(Top))
  add(query_593918, "$skip", newJString(Skip))
  add(query_593918, "$filter", newJString(Filter))
  result = call_593915.call(path_593916, query_593918, nil, nil, nil)

var softwareUpdateConfigurationRunsList* = Call_SoftwareUpdateConfigurationRunsList_593647(
    name: "softwareUpdateConfigurationRunsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationRuns",
    validator: validate_SoftwareUpdateConfigurationRunsList_593648, base: "/",
    url: url_SoftwareUpdateConfigurationRunsList_593649, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationRunsGetById_593957 = ref object of OpenApiRestCall_593425
proc url_SoftwareUpdateConfigurationRunsGetById_593959(protocol: Scheme;
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
  assert "softwareUpdateConfigurationRunId" in path,
        "`softwareUpdateConfigurationRunId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurationRuns/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationRunId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationRunsGetById_593958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single software update configuration Run by Id.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationrunoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   softwareUpdateConfigurationRunId: JString (required)
  ##                                   : The Id of the software update configuration run.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593960 = path.getOrDefault("automationAccountName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "automationAccountName", valid_593960
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  var valid_593963 = path.getOrDefault("softwareUpdateConfigurationRunId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "softwareUpdateConfigurationRunId", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593965 = header.getOrDefault("clientRequestId")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "clientRequestId", valid_593965
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_SoftwareUpdateConfigurationRunsGetById_593957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single software update configuration Run by Id.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationrunoperations
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_SoftwareUpdateConfigurationRunsGetById_593957;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          softwareUpdateConfigurationRunId: string): Recallable =
  ## softwareUpdateConfigurationRunsGetById
  ## Get a single software update configuration Run by Id.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationrunoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   softwareUpdateConfigurationRunId: string (required)
  ##                                   : The Id of the software update configuration run.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "automationAccountName", newJString(automationAccountName))
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  add(path_593968, "softwareUpdateConfigurationRunId",
      newJString(softwareUpdateConfigurationRunId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var softwareUpdateConfigurationRunsGetById* = Call_SoftwareUpdateConfigurationRunsGetById_593957(
    name: "softwareUpdateConfigurationRunsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationRuns/{softwareUpdateConfigurationRunId}",
    validator: validate_SoftwareUpdateConfigurationRunsGetById_593958, base: "/",
    url: url_SoftwareUpdateConfigurationRunsGetById_593959,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
