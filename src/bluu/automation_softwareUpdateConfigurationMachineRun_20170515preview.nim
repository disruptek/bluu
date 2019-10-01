
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "automation-softwareUpdateConfigurationMachineRun"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwareUpdateConfigurationMachineRunsList_596679 = ref object of OpenApiRestCall_596457
proc url_SoftwareUpdateConfigurationMachineRunsList_596681(protocol: Scheme;
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

proc validate_SoftwareUpdateConfigurationMachineRunsList_596680(path: JsonNode;
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
  ##   $top: JString
  ##       : Maximum number of entries returned in the results collection
  ##   $skip: JString
  ##        : number of entries you skip before returning results
  ##   $filter: JString
  ##          : The filter to apply on the operation. You can use the following filters: 'properties/osType', 'properties/status', 'properties/startTime', and 'properties/softwareUpdateConfiguration/name'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  var valid_596846 = query.getOrDefault("$top")
  valid_596846 = validateParameter(valid_596846, JString, required = false,
                                 default = nil)
  if valid_596846 != nil:
    section.add "$top", valid_596846
  var valid_596847 = query.getOrDefault("$skip")
  valid_596847 = validateParameter(valid_596847, JString, required = false,
                                 default = nil)
  if valid_596847 != nil:
    section.add "$skip", valid_596847
  var valid_596848 = query.getOrDefault("$filter")
  valid_596848 = validateParameter(valid_596848, JString, required = false,
                                 default = nil)
  if valid_596848 != nil:
    section.add "$filter", valid_596848
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_596849 = header.getOrDefault("clientRequestId")
  valid_596849 = validateParameter(valid_596849, JString, required = false,
                                 default = nil)
  if valid_596849 != nil:
    section.add "clientRequestId", valid_596849
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596876: Call_SoftwareUpdateConfigurationMachineRunsList_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Return list of software update configuration machine runs
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_596876.validator(path, query, header, formData, body)
  let scheme = call_596876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596876.url(scheme.get, call_596876.host, call_596876.base,
                         call_596876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596876, url, valid)

proc call*(call_596947: Call_SoftwareUpdateConfigurationMachineRunsList_596679;
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
  var path_596948 = newJObject()
  var query_596950 = newJObject()
  add(path_596948, "automationAccountName", newJString(automationAccountName))
  add(path_596948, "resourceGroupName", newJString(resourceGroupName))
  add(query_596950, "api-version", newJString(apiVersion))
  add(path_596948, "subscriptionId", newJString(subscriptionId))
  add(query_596950, "$top", newJString(Top))
  add(query_596950, "$skip", newJString(Skip))
  add(query_596950, "$filter", newJString(Filter))
  result = call_596947.call(path_596948, query_596950, nil, nil, nil)

var softwareUpdateConfigurationMachineRunsList* = Call_SoftwareUpdateConfigurationMachineRunsList_596679(
    name: "softwareUpdateConfigurationMachineRunsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationMachineRuns",
    validator: validate_SoftwareUpdateConfigurationMachineRunsList_596680,
    base: "/", url: url_SoftwareUpdateConfigurationMachineRunsList_596681,
    schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationMachineRunsGetById_596989 = ref object of OpenApiRestCall_596457
proc url_SoftwareUpdateConfigurationMachineRunsGetById_596991(protocol: Scheme;
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

proc validate_SoftwareUpdateConfigurationMachineRunsGetById_596990(
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
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  var valid_596995 = path.getOrDefault("softwareUpdateConfigurationMachineRunId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "softwareUpdateConfigurationMachineRunId", valid_596995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596996 = query.getOrDefault("api-version")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "api-version", valid_596996
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_596997 = header.getOrDefault("clientRequestId")
  valid_596997 = validateParameter(valid_596997, JString, required = false,
                                 default = nil)
  if valid_596997 != nil:
    section.add "clientRequestId", valid_596997
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596998: Call_SoftwareUpdateConfigurationMachineRunsGetById_596989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single software update configuration machine run by Id.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_596998.validator(path, query, header, formData, body)
  let scheme = call_596998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596998.url(scheme.get, call_596998.host, call_596998.base,
                         call_596998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596998, url, valid)

proc call*(call_596999: Call_SoftwareUpdateConfigurationMachineRunsGetById_596989;
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
  var path_597000 = newJObject()
  var query_597001 = newJObject()
  add(path_597000, "automationAccountName", newJString(automationAccountName))
  add(path_597000, "resourceGroupName", newJString(resourceGroupName))
  add(query_597001, "api-version", newJString(apiVersion))
  add(path_597000, "subscriptionId", newJString(subscriptionId))
  add(path_597000, "softwareUpdateConfigurationMachineRunId",
      newJString(softwareUpdateConfigurationMachineRunId))
  result = call_596999.call(path_597000, query_597001, nil, nil, nil)

var softwareUpdateConfigurationMachineRunsGetById* = Call_SoftwareUpdateConfigurationMachineRunsGetById_596989(
    name: "softwareUpdateConfigurationMachineRunsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationMachineRuns/{softwareUpdateConfigurationMachineRunId}",
    validator: validate_SoftwareUpdateConfigurationMachineRunsGetById_596990,
    base: "/", url: url_SoftwareUpdateConfigurationMachineRunsGetById_596991,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
