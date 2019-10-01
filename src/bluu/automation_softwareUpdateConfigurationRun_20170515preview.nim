
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

  OpenApiRestCall_582458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582458): Option[Scheme] {.used.} =
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
  macServiceName = "automation-softwareUpdateConfigurationRun"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwareUpdateConfigurationRunsList_582680 = ref object of OpenApiRestCall_582458
proc url_SoftwareUpdateConfigurationRunsList_582682(protocol: Scheme; host: string;
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

proc validate_SoftwareUpdateConfigurationRunsList_582681(path: JsonNode;
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
  var valid_582843 = path.getOrDefault("automationAccountName")
  valid_582843 = validateParameter(valid_582843, JString, required = true,
                                 default = nil)
  if valid_582843 != nil:
    section.add "automationAccountName", valid_582843
  var valid_582844 = path.getOrDefault("resourceGroupName")
  valid_582844 = validateParameter(valid_582844, JString, required = true,
                                 default = nil)
  if valid_582844 != nil:
    section.add "resourceGroupName", valid_582844
  var valid_582845 = path.getOrDefault("subscriptionId")
  valid_582845 = validateParameter(valid_582845, JString, required = true,
                                 default = nil)
  if valid_582845 != nil:
    section.add "subscriptionId", valid_582845
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
  var valid_582846 = query.getOrDefault("api-version")
  valid_582846 = validateParameter(valid_582846, JString, required = true,
                                 default = nil)
  if valid_582846 != nil:
    section.add "api-version", valid_582846
  var valid_582847 = query.getOrDefault("$top")
  valid_582847 = validateParameter(valid_582847, JString, required = false,
                                 default = nil)
  if valid_582847 != nil:
    section.add "$top", valid_582847
  var valid_582848 = query.getOrDefault("$skip")
  valid_582848 = validateParameter(valid_582848, JString, required = false,
                                 default = nil)
  if valid_582848 != nil:
    section.add "$skip", valid_582848
  var valid_582849 = query.getOrDefault("$filter")
  valid_582849 = validateParameter(valid_582849, JString, required = false,
                                 default = nil)
  if valid_582849 != nil:
    section.add "$filter", valid_582849
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_582850 = header.getOrDefault("clientRequestId")
  valid_582850 = validateParameter(valid_582850, JString, required = false,
                                 default = nil)
  if valid_582850 != nil:
    section.add "clientRequestId", valid_582850
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582877: Call_SoftwareUpdateConfigurationRunsList_582680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Return list of software update configuration runs
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_582877.validator(path, query, header, formData, body)
  let scheme = call_582877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582877.url(scheme.get, call_582877.host, call_582877.base,
                         call_582877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582877, url, valid)

proc call*(call_582948: Call_SoftwareUpdateConfigurationRunsList_582680;
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
  var path_582949 = newJObject()
  var query_582951 = newJObject()
  add(path_582949, "automationAccountName", newJString(automationAccountName))
  add(path_582949, "resourceGroupName", newJString(resourceGroupName))
  add(query_582951, "api-version", newJString(apiVersion))
  add(path_582949, "subscriptionId", newJString(subscriptionId))
  add(query_582951, "$top", newJString(Top))
  add(query_582951, "$skip", newJString(Skip))
  add(query_582951, "$filter", newJString(Filter))
  result = call_582948.call(path_582949, query_582951, nil, nil, nil)

var softwareUpdateConfigurationRunsList* = Call_SoftwareUpdateConfigurationRunsList_582680(
    name: "softwareUpdateConfigurationRunsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationRuns",
    validator: validate_SoftwareUpdateConfigurationRunsList_582681, base: "/",
    url: url_SoftwareUpdateConfigurationRunsList_582682, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationRunsGetById_582990 = ref object of OpenApiRestCall_582458
proc url_SoftwareUpdateConfigurationRunsGetById_582992(protocol: Scheme;
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

proc validate_SoftwareUpdateConfigurationRunsGetById_582991(path: JsonNode;
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
  var valid_582993 = path.getOrDefault("automationAccountName")
  valid_582993 = validateParameter(valid_582993, JString, required = true,
                                 default = nil)
  if valid_582993 != nil:
    section.add "automationAccountName", valid_582993
  var valid_582994 = path.getOrDefault("resourceGroupName")
  valid_582994 = validateParameter(valid_582994, JString, required = true,
                                 default = nil)
  if valid_582994 != nil:
    section.add "resourceGroupName", valid_582994
  var valid_582995 = path.getOrDefault("subscriptionId")
  valid_582995 = validateParameter(valid_582995, JString, required = true,
                                 default = nil)
  if valid_582995 != nil:
    section.add "subscriptionId", valid_582995
  var valid_582996 = path.getOrDefault("softwareUpdateConfigurationRunId")
  valid_582996 = validateParameter(valid_582996, JString, required = true,
                                 default = nil)
  if valid_582996 != nil:
    section.add "softwareUpdateConfigurationRunId", valid_582996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582997 = query.getOrDefault("api-version")
  valid_582997 = validateParameter(valid_582997, JString, required = true,
                                 default = nil)
  if valid_582997 != nil:
    section.add "api-version", valid_582997
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_582998 = header.getOrDefault("clientRequestId")
  valid_582998 = validateParameter(valid_582998, JString, required = false,
                                 default = nil)
  if valid_582998 != nil:
    section.add "clientRequestId", valid_582998
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582999: Call_SoftwareUpdateConfigurationRunsGetById_582990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single software update configuration Run by Id.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationrunoperations
  let valid = call_582999.validator(path, query, header, formData, body)
  let scheme = call_582999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582999.url(scheme.get, call_582999.host, call_582999.base,
                         call_582999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582999, url, valid)

proc call*(call_583000: Call_SoftwareUpdateConfigurationRunsGetById_582990;
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
  var path_583001 = newJObject()
  var query_583002 = newJObject()
  add(path_583001, "automationAccountName", newJString(automationAccountName))
  add(path_583001, "resourceGroupName", newJString(resourceGroupName))
  add(query_583002, "api-version", newJString(apiVersion))
  add(path_583001, "subscriptionId", newJString(subscriptionId))
  add(path_583001, "softwareUpdateConfigurationRunId",
      newJString(softwareUpdateConfigurationRunId))
  result = call_583000.call(path_583001, query_583002, nil, nil, nil)

var softwareUpdateConfigurationRunsGetById* = Call_SoftwareUpdateConfigurationRunsGetById_582990(
    name: "softwareUpdateConfigurationRunsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurationRuns/{softwareUpdateConfigurationRunId}",
    validator: validate_SoftwareUpdateConfigurationRunsGetById_582991, base: "/",
    url: url_SoftwareUpdateConfigurationRunsGetById_582992,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
