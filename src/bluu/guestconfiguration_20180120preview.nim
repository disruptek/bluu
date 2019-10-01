
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "guestconfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567864 = ref object of OpenApiRestCall_567642
proc url_OperationsList_567866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567865(path: JsonNode; query: JsonNode;
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
  var valid_568012 = query.getOrDefault("api-version")
  valid_568012 = validateParameter(valid_568012, JString, required = true,
                                 default = nil)
  if valid_568012 != nil:
    section.add "api-version", valid_568012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568039: Call_OperationsList_567864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available GuestConfiguration REST API operations.
  ## 
  let valid = call_568039.validator(path, query, header, formData, body)
  let scheme = call_568039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568039.url(scheme.get, call_568039.host, call_568039.base,
                         call_568039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568039, url, valid)

proc call*(call_568110: Call_OperationsList_567864; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available GuestConfiguration REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568111 = newJObject()
  add(query_568111, "api-version", newJString(apiVersion))
  result = call_568110.call(nil, query_568111, nil, nil, nil)

var operationsList* = Call_OperationsList_567864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.GuestConfiguration/operations",
    validator: validate_OperationsList_567865, base: "", url: url_OperationsList_567866,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentsCreateOrUpdate_568177 = ref object of OpenApiRestCall_567642
proc url_GuestConfigurationAssignmentsCreateOrUpdate_568179(protocol: Scheme;
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

proc validate_GuestConfigurationAssignmentsCreateOrUpdate_568178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an association between a VM and guest configuration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : Name of the guest configuration assignment.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "guestConfigurationAssignmentName", valid_568207
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("vmName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "vmName", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
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

proc call*(call_568212: Call_GuestConfigurationAssignmentsCreateOrUpdate_568177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an association between a VM and guest configuration
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_GuestConfigurationAssignmentsCreateOrUpdate_568177;
          resourceGroupName: string; apiVersion: string;
          guestConfigurationAssignmentName: string; subscriptionId: string;
          vmName: string; parameters: JsonNode): Recallable =
  ## guestConfigurationAssignmentsCreateOrUpdate
  ## Creates an association between a VM and guest configuration
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : Name of the guest configuration assignment.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update guest configuration assignment.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  var body_568216 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(path_568214, "vmName", newJString(vmName))
  if parameters != nil:
    body_568216 = parameters
  result = call_568213.call(path_568214, query_568215, nil, nil, body_568216)

var guestConfigurationAssignmentsCreateOrUpdate* = Call_GuestConfigurationAssignmentsCreateOrUpdate_568177(
    name: "guestConfigurationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsCreateOrUpdate_568178,
    base: "", url: url_GuestConfigurationAssignmentsCreateOrUpdate_568179,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentsGet_568151 = ref object of OpenApiRestCall_567642
proc url_GuestConfigurationAssignmentsGet_568153(protocol: Scheme; host: string;
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

proc validate_GuestConfigurationAssignmentsGet_568152(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a guest configuration assignment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : The guest configuration assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568168 = path.getOrDefault("resourceGroupName")
  valid_568168 = validateParameter(valid_568168, JString, required = true,
                                 default = nil)
  if valid_568168 != nil:
    section.add "resourceGroupName", valid_568168
  var valid_568169 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_568169 = validateParameter(valid_568169, JString, required = true,
                                 default = nil)
  if valid_568169 != nil:
    section.add "guestConfigurationAssignmentName", valid_568169
  var valid_568170 = path.getOrDefault("subscriptionId")
  valid_568170 = validateParameter(valid_568170, JString, required = true,
                                 default = nil)
  if valid_568170 != nil:
    section.add "subscriptionId", valid_568170
  var valid_568171 = path.getOrDefault("vmName")
  valid_568171 = validateParameter(valid_568171, JString, required = true,
                                 default = nil)
  if valid_568171 != nil:
    section.add "vmName", valid_568171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568172 = query.getOrDefault("api-version")
  valid_568172 = validateParameter(valid_568172, JString, required = true,
                                 default = nil)
  if valid_568172 != nil:
    section.add "api-version", valid_568172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568173: Call_GuestConfigurationAssignmentsGet_568151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a guest configuration assignment
  ## 
  let valid = call_568173.validator(path, query, header, formData, body)
  let scheme = call_568173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568173.url(scheme.get, call_568173.host, call_568173.base,
                         call_568173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568173, url, valid)

proc call*(call_568174: Call_GuestConfigurationAssignmentsGet_568151;
          resourceGroupName: string; apiVersion: string;
          guestConfigurationAssignmentName: string; subscriptionId: string;
          vmName: string): Recallable =
  ## guestConfigurationAssignmentsGet
  ## Get information about a guest configuration assignment
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : The guest configuration assignment name.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_568175 = newJObject()
  var query_568176 = newJObject()
  add(path_568175, "resourceGroupName", newJString(resourceGroupName))
  add(query_568176, "api-version", newJString(apiVersion))
  add(path_568175, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_568175, "subscriptionId", newJString(subscriptionId))
  add(path_568175, "vmName", newJString(vmName))
  result = call_568174.call(path_568175, query_568176, nil, nil, nil)

var guestConfigurationAssignmentsGet* = Call_GuestConfigurationAssignmentsGet_568151(
    name: "guestConfigurationAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsGet_568152, base: "",
    url: url_GuestConfigurationAssignmentsGet_568153, schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentReportsList_568217 = ref object of OpenApiRestCall_567642
proc url_GuestConfigurationAssignmentReportsList_568219(protocol: Scheme;
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

proc validate_GuestConfigurationAssignmentReportsList_568218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all reports for the guest configuration assignment, latest report first.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : The guest configuration assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "guestConfigurationAssignmentName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("vmName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "vmName", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_GuestConfigurationAssignmentReportsList_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reports for the guest configuration assignment, latest report first.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_GuestConfigurationAssignmentReportsList_568217;
          resourceGroupName: string; apiVersion: string;
          guestConfigurationAssignmentName: string; subscriptionId: string;
          vmName: string): Recallable =
  ## guestConfigurationAssignmentReportsList
  ## List all reports for the guest configuration assignment, latest report first.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : The guest configuration assignment name.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  add(path_568227, "vmName", newJString(vmName))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var guestConfigurationAssignmentReportsList* = Call_GuestConfigurationAssignmentReportsList_568217(
    name: "guestConfigurationAssignmentReportsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}/reports",
    validator: validate_GuestConfigurationAssignmentReportsList_568218, base: "",
    url: url_GuestConfigurationAssignmentReportsList_568219,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentReportsGet_568229 = ref object of OpenApiRestCall_567642
proc url_GuestConfigurationAssignmentReportsGet_568231(protocol: Scheme;
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

proc validate_GuestConfigurationAssignmentReportsGet_568230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a report for the guest configuration assignment, by reportId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : The guest configuration assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  ##   reportId: JString (required)
  ##           : The GUID for the guest configuration assignment report.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "guestConfigurationAssignmentName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  var valid_568235 = path.getOrDefault("vmName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "vmName", valid_568235
  var valid_568236 = path.getOrDefault("reportId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "reportId", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_GuestConfigurationAssignmentReportsGet_568229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a report for the guest configuration assignment, by reportId.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_GuestConfigurationAssignmentReportsGet_568229;
          resourceGroupName: string; apiVersion: string;
          guestConfigurationAssignmentName: string; subscriptionId: string;
          vmName: string; reportId: string): Recallable =
  ## guestConfigurationAssignmentReportsGet
  ## Get a report for the guest configuration assignment, by reportId.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : The guest configuration assignment name.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   reportId: string (required)
  ##           : The GUID for the guest configuration assignment report.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(path_568240, "resourceGroupName", newJString(resourceGroupName))
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_568240, "subscriptionId", newJString(subscriptionId))
  add(path_568240, "vmName", newJString(vmName))
  add(path_568240, "reportId", newJString(reportId))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var guestConfigurationAssignmentReportsGet* = Call_GuestConfigurationAssignmentReportsGet_568229(
    name: "guestConfigurationAssignmentReportsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}/reports/{reportId}",
    validator: validate_GuestConfigurationAssignmentReportsGet_568230, base: "",
    url: url_GuestConfigurationAssignmentReportsGet_568231,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
