
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "guestconfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593631 = ref object of OpenApiRestCall_593409
proc url_OperationsList_593633(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593632(path: JsonNode; query: JsonNode;
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
  var valid_593779 = query.getOrDefault("api-version")
  valid_593779 = validateParameter(valid_593779, JString, required = true,
                                 default = nil)
  if valid_593779 != nil:
    section.add "api-version", valid_593779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593806: Call_OperationsList_593631; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available GuestConfiguration REST API operations.
  ## 
  let valid = call_593806.validator(path, query, header, formData, body)
  let scheme = call_593806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593806.url(scheme.get, call_593806.host, call_593806.base,
                         call_593806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593806, url, valid)

proc call*(call_593877: Call_OperationsList_593631; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available GuestConfiguration REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593878 = newJObject()
  add(query_593878, "api-version", newJString(apiVersion))
  result = call_593877.call(nil, query_593878, nil, nil, nil)

var operationsList* = Call_OperationsList_593631(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.GuestConfiguration/operations",
    validator: validate_OperationsList_593632, base: "", url: url_OperationsList_593633,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentsCreateOrUpdate_593944 = ref object of OpenApiRestCall_593409
proc url_GuestConfigurationAssignmentsCreateOrUpdate_593946(protocol: Scheme;
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

proc validate_GuestConfigurationAssignmentsCreateOrUpdate_593945(path: JsonNode;
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
  var valid_593973 = path.getOrDefault("resourceGroupName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "resourceGroupName", valid_593973
  var valid_593974 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "guestConfigurationAssignmentName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("vmName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "vmName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
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

proc call*(call_593979: Call_GuestConfigurationAssignmentsCreateOrUpdate_593944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an association between a VM and guest configuration
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_GuestConfigurationAssignmentsCreateOrUpdate_593944;
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
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(path_593981, "resourceGroupName", newJString(resourceGroupName))
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  add(path_593981, "vmName", newJString(vmName))
  if parameters != nil:
    body_593983 = parameters
  result = call_593980.call(path_593981, query_593982, nil, nil, body_593983)

var guestConfigurationAssignmentsCreateOrUpdate* = Call_GuestConfigurationAssignmentsCreateOrUpdate_593944(
    name: "guestConfigurationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsCreateOrUpdate_593945,
    base: "", url: url_GuestConfigurationAssignmentsCreateOrUpdate_593946,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentsGet_593918 = ref object of OpenApiRestCall_593409
proc url_GuestConfigurationAssignmentsGet_593920(protocol: Scheme; host: string;
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

proc validate_GuestConfigurationAssignmentsGet_593919(path: JsonNode;
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
  var valid_593935 = path.getOrDefault("resourceGroupName")
  valid_593935 = validateParameter(valid_593935, JString, required = true,
                                 default = nil)
  if valid_593935 != nil:
    section.add "resourceGroupName", valid_593935
  var valid_593936 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_593936 = validateParameter(valid_593936, JString, required = true,
                                 default = nil)
  if valid_593936 != nil:
    section.add "guestConfigurationAssignmentName", valid_593936
  var valid_593937 = path.getOrDefault("subscriptionId")
  valid_593937 = validateParameter(valid_593937, JString, required = true,
                                 default = nil)
  if valid_593937 != nil:
    section.add "subscriptionId", valid_593937
  var valid_593938 = path.getOrDefault("vmName")
  valid_593938 = validateParameter(valid_593938, JString, required = true,
                                 default = nil)
  if valid_593938 != nil:
    section.add "vmName", valid_593938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593939 = query.getOrDefault("api-version")
  valid_593939 = validateParameter(valid_593939, JString, required = true,
                                 default = nil)
  if valid_593939 != nil:
    section.add "api-version", valid_593939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593940: Call_GuestConfigurationAssignmentsGet_593918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a guest configuration assignment
  ## 
  let valid = call_593940.validator(path, query, header, formData, body)
  let scheme = call_593940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593940.url(scheme.get, call_593940.host, call_593940.base,
                         call_593940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593940, url, valid)

proc call*(call_593941: Call_GuestConfigurationAssignmentsGet_593918;
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
  var path_593942 = newJObject()
  var query_593943 = newJObject()
  add(path_593942, "resourceGroupName", newJString(resourceGroupName))
  add(query_593943, "api-version", newJString(apiVersion))
  add(path_593942, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_593942, "subscriptionId", newJString(subscriptionId))
  add(path_593942, "vmName", newJString(vmName))
  result = call_593941.call(path_593942, query_593943, nil, nil, nil)

var guestConfigurationAssignmentsGet* = Call_GuestConfigurationAssignmentsGet_593918(
    name: "guestConfigurationAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsGet_593919, base: "",
    url: url_GuestConfigurationAssignmentsGet_593920, schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentReportsList_593984 = ref object of OpenApiRestCall_593409
proc url_GuestConfigurationAssignmentReportsList_593986(protocol: Scheme;
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

proc validate_GuestConfigurationAssignmentReportsList_593985(path: JsonNode;
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
  var valid_593987 = path.getOrDefault("resourceGroupName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "resourceGroupName", valid_593987
  var valid_593988 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "guestConfigurationAssignmentName", valid_593988
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  var valid_593990 = path.getOrDefault("vmName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "vmName", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_GuestConfigurationAssignmentReportsList_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reports for the guest configuration assignment, latest report first.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_GuestConfigurationAssignmentReportsList_593984;
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
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(path_593994, "resourceGroupName", newJString(resourceGroupName))
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  add(path_593994, "vmName", newJString(vmName))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var guestConfigurationAssignmentReportsList* = Call_GuestConfigurationAssignmentReportsList_593984(
    name: "guestConfigurationAssignmentReportsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}/reports",
    validator: validate_GuestConfigurationAssignmentReportsList_593985, base: "",
    url: url_GuestConfigurationAssignmentReportsList_593986,
    schemes: {Scheme.Https})
type
  Call_GuestConfigurationAssignmentReportsGet_593996 = ref object of OpenApiRestCall_593409
proc url_GuestConfigurationAssignmentReportsGet_593998(protocol: Scheme;
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

proc validate_GuestConfigurationAssignmentReportsGet_593997(path: JsonNode;
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
  var valid_593999 = path.getOrDefault("resourceGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceGroupName", valid_593999
  var valid_594000 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "guestConfigurationAssignmentName", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  var valid_594002 = path.getOrDefault("vmName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "vmName", valid_594002
  var valid_594003 = path.getOrDefault("reportId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "reportId", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_GuestConfigurationAssignmentReportsGet_593996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a report for the guest configuration assignment, by reportId.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_GuestConfigurationAssignmentReportsGet_593996;
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
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(path_594007, "resourceGroupName", newJString(resourceGroupName))
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_594007, "subscriptionId", newJString(subscriptionId))
  add(path_594007, "vmName", newJString(vmName))
  add(path_594007, "reportId", newJString(reportId))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var guestConfigurationAssignmentReportsGet* = Call_GuestConfigurationAssignmentReportsGet_593996(
    name: "guestConfigurationAssignmentReportsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}/reports/{reportId}",
    validator: validate_GuestConfigurationAssignmentReportsGet_593997, base: "",
    url: url_GuestConfigurationAssignmentReportsGet_593998,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
