
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "automation-softwareUpdateConfigurationMachineRun"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwareUpdateConfigurationMachineRunsList_593646 = ref object of OpenApiRestCall_593424
proc url_SoftwareUpdateConfigurationMachineRunsList_593648(protocol: Scheme;
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
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurationMachineRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationMachineRunsList_593647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return list of software update configuration machine runs
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
  var valid_593809 = path.getOrDefault("automationAccountName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "automationAccountName", valid_593809
  var valid_593810 = path.getOrDefault("resourceGroupName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroupName", valid_593810
  var valid_593811 = path.getOrDefault("subscriptionId")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "subscriptionId", valid_593811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JString
  ##       : Maximum number of entries returned in the results collection
  ##   $skip: JString
  ##        : number of entries you skip before returning results
  ##   $filter: JString
  ##          : The filter to apply on the operation. You can use the following filters: 'properties/osType', 'properties/status', 'properties/startTime', and 'properties/softwareUpdateConfiguration/name'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593812 = query.getOrDefault("api-version")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "api-version", valid_593812
  var valid_593813 = query.getOrDefault("$top")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "$top", valid_593813
  var valid_593814 = query.getOrDefault("$skip")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "$skip", valid_593814
  var valid_593815 = query.getOrDefault("$filter")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "$filter", valid_593815
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593816 = header.getOrDefault("clientRequestId")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "clientRequestId", valid_593816
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_SoftwareUpdateConfigurationMachineRunsList_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Return list of software update configuration machine runs
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_SoftwareUpdateConfigurationMachineRunsList_593646;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: string = "";
          Skip: string = ""; Filter: string = ""): Recallable =
  ## softwareUpdateConfigurationMachineRunsList
  ## Return list of software update configuration machine runs
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
  ##       : number of entries you skip before returning results
  ##   Filter: string
  ##         : The filter to apply on the operation. You can use the following filters: 'properties/osType', 'properties/status', 'properties/startTime', and 'properties/softwareUpdateConfiguration/name'
  var path_593915 = newJObject()
  var query_593917 = newJObject()
  add(path_593915, "automationAccountName", newJString(automationAccountName))
  add(path_593915, "resourceGroupName", newJString(resourceGroupName))
  add(query_593917, "api-version", newJString(apiVersion))
  add(path_593915, "subscriptionId", newJString(subscriptionId))
  add(query_593917, "$top", newJString(Top))
  add(query_593917, "$skip", newJString(Skip))
  add(query_593917, "$filter", newJString(Filter))
  result = call_593914.call(path_593915, query_593917, nil, nil, nil)

var softwareUpdateConfigurationMachineRunsList* = Call_SoftwareUpdateConfigurationMachineRunsList_593646(
    name: "softwareUpdateConfigurationMachineRunsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationMachineRuns",
    validator: validate_SoftwareUpdateConfigurationMachineRunsList_593647,
    base: "/", url: url_SoftwareUpdateConfigurationMachineRunsList_593648,
    schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationMachineRunsGetById_593956 = ref object of OpenApiRestCall_593424
proc url_SoftwareUpdateConfigurationMachineRunsGetById_593958(protocol: Scheme;
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
  assert "softwareUpdateConfigurationMachineRunId" in path, "`softwareUpdateConfigurationMachineRunId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurationMachineRuns/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationMachineRunId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationMachineRunsGetById_593957(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a single software update configuration machine run by Id.
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
  ##   softwareUpdateConfigurationMachineRunId: JString (required)
  ##                                          : The Id of the software update configuration machine run.
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
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  var valid_593962 = path.getOrDefault("softwareUpdateConfigurationMachineRunId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "softwareUpdateConfigurationMachineRunId", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593964 = header.getOrDefault("clientRequestId")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "clientRequestId", valid_593964
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_SoftwareUpdateConfigurationMachineRunsGetById_593956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single software update configuration machine run by Id.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_SoftwareUpdateConfigurationMachineRunsGetById_593956;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          softwareUpdateConfigurationMachineRunId: string): Recallable =
  ## softwareUpdateConfigurationMachineRunsGetById
  ## Get a single software update configuration machine run by Id.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   softwareUpdateConfigurationMachineRunId: string (required)
  ##                                          : The Id of the software update configuration machine run.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(path_593967, "automationAccountName", newJString(automationAccountName))
  add(path_593967, "resourceGroupName", newJString(resourceGroupName))
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  add(path_593967, "softwareUpdateConfigurationMachineRunId",
      newJString(softwareUpdateConfigurationMachineRunId))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var softwareUpdateConfigurationMachineRunsGetById* = Call_SoftwareUpdateConfigurationMachineRunsGetById_593956(
    name: "softwareUpdateConfigurationMachineRunsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationMachineRuns/{softwareUpdateConfigurationMachineRunId}",
    validator: validate_SoftwareUpdateConfigurationMachineRunsGetById_593957,
    base: "/", url: url_SoftwareUpdateConfigurationMachineRunsGetById_593958,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
