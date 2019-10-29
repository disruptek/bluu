
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: GuestConfiguration
## version: 2018-01-20-preview
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "guestconfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563762 = ref object of OpenApiRestCall_563540
proc url_OperationsList_563764(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563763(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available GuestConfiguration REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563912 = query.getOrDefault("api-version")
  valid_563912 = validateParameter(valid_563912, JString, required = true,
                                 default = nil)
  if valid_563912 != nil:
    section.add "api-version", valid_563912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563939: Call_OperationsList_563762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available GuestConfiguration REST API operations.
  ## 
  let valid = call_563939.validator(path, query, header, formData, body)
  let scheme = call_563939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563939.url(scheme.get, call_563939.host, call_563939.base,
                         call_563939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563939, url, valid)

proc call*(call_564010: Call_OperationsList_563762; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available GuestConfiguration REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564011 = newJObject()
  add(query_564011, "api-version", newJString(apiVersion))
  result = call_564010.call(nil, query_564011, nil, nil, nil)

var operationsList* = Call_OperationsList_563762(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.GuestConfiguration/operations",
    validator: validate_OperationsList_563763, base: "", url: url_OperationsList_563764,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentsCreateOrUpdate_564077 = ref object of OpenApiRestCall_563540
proc url_GuestConfigurationAssignmentsCreateOrUpdate_564079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "guestConfigurationAssignmentName" in path,
        "`guestConfigurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"), (kind: ConstantSegment, value: "/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/"), (
        kind: VariableSegment, value: "guestConfigurationAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestConfigurationAssignmentsCreateOrUpdate_564078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an association between a VM and guest configuration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : Name of the guest configuration assignment.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "guestConfigurationAssignmentName", valid_564107
  var valid_564108 = path.getOrDefault("resourceGroupName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "resourceGroupName", valid_564108
  var valid_564109 = path.getOrDefault("vmName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "vmName", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update guest configuration assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_GuestConfigurationAssignmentsCreateOrUpdate_564077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an association between a VM and guest configuration
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_GuestConfigurationAssignmentsCreateOrUpdate_564077;
          apiVersion: string; subscriptionId: string;
          guestConfigurationAssignmentName: string; resourceGroupName: string;
          parameters: JsonNode; vmName: string): Recallable =
  ## guestConfigurationAssignmentsCreateOrUpdate
  ## Creates an association between a VM and guest configuration
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : Name of the guest configuration assignment.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update guest configuration assignment.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  var body_564116 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "subscriptionId", newJString(subscriptionId))
  add(path_564114, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_564114, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564116 = parameters
  add(path_564114, "vmName", newJString(vmName))
  result = call_564113.call(path_564114, query_564115, nil, nil, body_564116)

var guestConfigurationAssignmentsCreateOrUpdate* = Call_GuestConfigurationAssignmentsCreateOrUpdate_564077(
    name: "guestConfigurationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsCreateOrUpdate_564078,
    base: "", url: url_GuestConfigurationAssignmentsCreateOrUpdate_564079,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentsGet_564051 = ref object of OpenApiRestCall_563540
proc url_GuestConfigurationAssignmentsGet_564053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "guestConfigurationAssignmentName" in path,
        "`guestConfigurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"), (kind: ConstantSegment, value: "/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/"), (
        kind: VariableSegment, value: "guestConfigurationAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestConfigurationAssignmentsGet_564052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a guest configuration assignment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : The guest configuration assignment name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564068 = path.getOrDefault("subscriptionId")
  valid_564068 = validateParameter(valid_564068, JString, required = true,
                                 default = nil)
  if valid_564068 != nil:
    section.add "subscriptionId", valid_564068
  var valid_564069 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_564069 = validateParameter(valid_564069, JString, required = true,
                                 default = nil)
  if valid_564069 != nil:
    section.add "guestConfigurationAssignmentName", valid_564069
  var valid_564070 = path.getOrDefault("resourceGroupName")
  valid_564070 = validateParameter(valid_564070, JString, required = true,
                                 default = nil)
  if valid_564070 != nil:
    section.add "resourceGroupName", valid_564070
  var valid_564071 = path.getOrDefault("vmName")
  valid_564071 = validateParameter(valid_564071, JString, required = true,
                                 default = nil)
  if valid_564071 != nil:
    section.add "vmName", valid_564071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564072 = query.getOrDefault("api-version")
  valid_564072 = validateParameter(valid_564072, JString, required = true,
                                 default = nil)
  if valid_564072 != nil:
    section.add "api-version", valid_564072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564073: Call_GuestConfigurationAssignmentsGet_564051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a guest configuration assignment
  ## 
  let valid = call_564073.validator(path, query, header, formData, body)
  let scheme = call_564073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564073.url(scheme.get, call_564073.host, call_564073.base,
                         call_564073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564073, url, valid)

proc call*(call_564074: Call_GuestConfigurationAssignmentsGet_564051;
          apiVersion: string; subscriptionId: string;
          guestConfigurationAssignmentName: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## guestConfigurationAssignmentsGet
  ## Get information about a guest configuration assignment
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : The guest configuration assignment name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_564075 = newJObject()
  var query_564076 = newJObject()
  add(query_564076, "api-version", newJString(apiVersion))
  add(path_564075, "subscriptionId", newJString(subscriptionId))
  add(path_564075, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_564075, "resourceGroupName", newJString(resourceGroupName))
  add(path_564075, "vmName", newJString(vmName))
  result = call_564074.call(path_564075, query_564076, nil, nil, nil)

var guestConfigurationAssignmentsGet* = Call_GuestConfigurationAssignmentsGet_564051(
    name: "guestConfigurationAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsGet_564052, base: "",
    url: url_GuestConfigurationAssignmentsGet_564053, schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentReportsList_564117 = ref object of OpenApiRestCall_563540
proc url_GuestConfigurationAssignmentReportsList_564119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "guestConfigurationAssignmentName" in path,
        "`guestConfigurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"), (kind: ConstantSegment, value: "/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/"), (
        kind: VariableSegment, value: "guestConfigurationAssignmentName"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestConfigurationAssignmentReportsList_564118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all reports for the guest configuration assignment, latest report first.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : The guest configuration assignment name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  var valid_564121 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "guestConfigurationAssignmentName", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  var valid_564123 = path.getOrDefault("vmName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "vmName", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_GuestConfigurationAssignmentReportsList_564117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reports for the guest configuration assignment, latest report first.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_GuestConfigurationAssignmentReportsList_564117;
          apiVersion: string; subscriptionId: string;
          guestConfigurationAssignmentName: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## guestConfigurationAssignmentReportsList
  ## List all reports for the guest configuration assignment, latest report first.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : The guest configuration assignment name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  add(path_564127, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_564127, "resourceGroupName", newJString(resourceGroupName))
  add(path_564127, "vmName", newJString(vmName))
  result = call_564126.call(path_564127, query_564128, nil, nil, nil)

var guestConfigurationAssignmentReportsList* = Call_GuestConfigurationAssignmentReportsList_564117(
    name: "guestConfigurationAssignmentReportsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}/reports",
    validator: validate_GuestConfigurationAssignmentReportsList_564118, base: "",
    url: url_GuestConfigurationAssignmentReportsList_564119,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentReportsGet_564129 = ref object of OpenApiRestCall_563540
proc url_GuestConfigurationAssignmentReportsGet_564131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "guestConfigurationAssignmentName" in path,
        "`guestConfigurationAssignmentName` is a required path parameter"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"), (kind: ConstantSegment, value: "/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/"), (
        kind: VariableSegment, value: "guestConfigurationAssignmentName"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestConfigurationAssignmentReportsGet_564130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a report for the guest configuration assignment, by reportId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : The guest configuration assignment name.
  ##   reportId: JString (required)
  ##           : The GUID for the guest configuration assignment report.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "guestConfigurationAssignmentName", valid_564133
  var valid_564134 = path.getOrDefault("reportId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "reportId", valid_564134
  var valid_564135 = path.getOrDefault("resourceGroupName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "resourceGroupName", valid_564135
  var valid_564136 = path.getOrDefault("vmName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "vmName", valid_564136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_GuestConfigurationAssignmentReportsGet_564129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a report for the guest configuration assignment, by reportId.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_GuestConfigurationAssignmentReportsGet_564129;
          apiVersion: string; subscriptionId: string;
          guestConfigurationAssignmentName: string; reportId: string;
          resourceGroupName: string; vmName: string): Recallable =
  ## guestConfigurationAssignmentReportsGet
  ## Get a report for the guest configuration assignment, by reportId.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : The guest configuration assignment name.
  ##   reportId: string (required)
  ##           : The GUID for the guest configuration assignment report.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  add(path_564140, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_564140, "reportId", newJString(reportId))
  add(path_564140, "resourceGroupName", newJString(resourceGroupName))
  add(path_564140, "vmName", newJString(vmName))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var guestConfigurationAssignmentReportsGet* = Call_GuestConfigurationAssignmentReportsGet_564129(
    name: "guestConfigurationAssignmentReportsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}/reports/{reportId}",
    validator: validate_GuestConfigurationAssignmentReportsGet_564130, base: "",
    url: url_GuestConfigurationAssignmentReportsGet_564131,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
