
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: GuestConfiguration
## version: 2018-06-30-preview
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "guestconfiguration-guestconfiguration_NotImplemented"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GuestConfigurationAssignmentsDelete_563761 = ref object of OpenApiRestCall_563539
proc url_GuestConfigurationAssignmentsDelete_563763(protocol: Scheme; host: string;
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

proc validate_GuestConfigurationAssignmentsDelete_563762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a guest configuration assignment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: JString (required)
  ##                                   : Name of the guest configuration assignment
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563925 = path.getOrDefault("subscriptionId")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "subscriptionId", valid_563925
  var valid_563926 = path.getOrDefault("guestConfigurationAssignmentName")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "guestConfigurationAssignmentName", valid_563926
  var valid_563927 = path.getOrDefault("resourceGroupName")
  valid_563927 = validateParameter(valid_563927, JString, required = true,
                                 default = nil)
  if valid_563927 != nil:
    section.add "resourceGroupName", valid_563927
  var valid_563928 = path.getOrDefault("vmName")
  valid_563928 = validateParameter(valid_563928, JString, required = true,
                                 default = nil)
  if valid_563928 != nil:
    section.add "vmName", valid_563928
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563929 = query.getOrDefault("api-version")
  valid_563929 = validateParameter(valid_563929, JString, required = true,
                                 default = nil)
  if valid_563929 != nil:
    section.add "api-version", valid_563929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563956: Call_GuestConfigurationAssignmentsDelete_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a guest configuration assignment
  ## 
  let valid = call_563956.validator(path, query, header, formData, body)
  let scheme = call_563956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563956.url(scheme.get, call_563956.host, call_563956.base,
                         call_563956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563956, url, valid)

proc call*(call_564027: Call_GuestConfigurationAssignmentsDelete_563761;
          apiVersion: string; subscriptionId: string;
          guestConfigurationAssignmentName: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## guestConfigurationAssignmentsDelete
  ## Delete a guest configuration assignment
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   guestConfigurationAssignmentName: string (required)
  ##                                   : Name of the guest configuration assignment
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_564028 = newJObject()
  var query_564030 = newJObject()
  add(query_564030, "api-version", newJString(apiVersion))
  add(path_564028, "subscriptionId", newJString(subscriptionId))
  add(path_564028, "guestConfigurationAssignmentName",
      newJString(guestConfigurationAssignmentName))
  add(path_564028, "resourceGroupName", newJString(resourceGroupName))
  add(path_564028, "vmName", newJString(vmName))
  result = call_564027.call(path_564028, query_564030, nil, nil, nil)

var guestConfigurationAssignmentsDelete* = Call_GuestConfigurationAssignmentsDelete_563761(
    name: "guestConfigurationAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/{guestConfigurationAssignmentName}",
    validator: validate_GuestConfigurationAssignmentsDelete_563762, base: "",
    url: url_GuestConfigurationAssignmentsDelete_563763, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
