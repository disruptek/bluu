
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ComputeDiskAdminManagementClient
## version: 2018-07-30-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Compute Disk Management Client.
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
  macServiceName = "azsadmin-Disks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DisksList_593647 = ref object of OpenApiRestCall_593425
proc url_DisksList_593649(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksList_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593809 = path.getOrDefault("subscriptionId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "subscriptionId", valid_593809
  var valid_593810 = path.getOrDefault("location")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "location", valid_593810
  result.add "path", section
  ## parameters in `query` object:
  ##   sharePath: JString
  ##            : The source share which the resource belongs to.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   userSubscriptionId: JString
  ##                     : User Subscription Id which the resource belongs to.
  ##   status: JString
  ##         : The parameters of disk state.
  ##   count: JInt
  ##        : The maximum number of disks to return.
  ##   start: JInt
  ##        : The start index of disks in query.
  section = newJObject()
  var valid_593811 = query.getOrDefault("sharePath")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "sharePath", valid_593811
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  var valid_593826 = query.getOrDefault("userSubscriptionId")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "userSubscriptionId", valid_593826
  var valid_593827 = query.getOrDefault("status")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "status", valid_593827
  var valid_593828 = query.getOrDefault("count")
  valid_593828 = validateParameter(valid_593828, JInt, required = false, default = nil)
  if valid_593828 != nil:
    section.add "count", valid_593828
  var valid_593829 = query.getOrDefault("start")
  valid_593829 = validateParameter(valid_593829, JInt, required = false, default = nil)
  if valid_593829 != nil:
    section.add "start", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593856: Call_DisksList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of disks.
  ## 
  let valid = call_593856.validator(path, query, header, formData, body)
  let scheme = call_593856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593856.url(scheme.get, call_593856.host, call_593856.base,
                         call_593856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593856, url, valid)

proc call*(call_593927: Call_DisksList_593647; subscriptionId: string;
          location: string; sharePath: string = "";
          apiVersion: string = "2018-07-30-preview";
          userSubscriptionId: string = ""; status: string = ""; count: int = 0;
          start: int = 0): Recallable =
  ## disksList
  ## Returns a list of disks.
  ##   sharePath: string
  ##            : The source share which the resource belongs to.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   userSubscriptionId: string
  ##                     : User Subscription Id which the resource belongs to.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   status: string
  ##         : The parameters of disk state.
  ##   count: int
  ##        : The maximum number of disks to return.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   start: int
  ##        : The start index of disks in query.
  var path_593928 = newJObject()
  var query_593930 = newJObject()
  add(query_593930, "sharePath", newJString(sharePath))
  add(query_593930, "api-version", newJString(apiVersion))
  add(query_593930, "userSubscriptionId", newJString(userSubscriptionId))
  add(path_593928, "subscriptionId", newJString(subscriptionId))
  add(query_593930, "status", newJString(status))
  add(query_593930, "count", newJInt(count))
  add(path_593928, "location", newJString(location))
  add(query_593930, "start", newJInt(start))
  result = call_593927.call(path_593928, query_593930, nil, nil, nil)

var disksList* = Call_DisksList_593647(name: "disksList", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/disks",
                                    validator: validate_DisksList_593648,
                                    base: "", url: url_DisksList_593649,
                                    schemes: {Scheme.Https})
type
  Call_DisksGet_593969 = ref object of OpenApiRestCall_593425
proc url_DisksGet_593971(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "DiskId" in path, "`DiskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "DiskId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksGet_593970(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   DiskId: JString (required)
  ##         : The disk guid as identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  var valid_593973 = path.getOrDefault("location")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "location", valid_593973
  var valid_593974 = path.getOrDefault("DiskId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "DiskId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_DisksGet_593969; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the disk.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_DisksGet_593969; subscriptionId: string;
          location: string; DiskId: string;
          apiVersion: string = "2018-07-30-preview"): Recallable =
  ## disksGet
  ## Returns the disk.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   DiskId: string (required)
  ##         : The disk guid as identity.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  add(path_593978, "location", newJString(location))
  add(path_593978, "DiskId", newJString(DiskId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var disksGet* = Call_DisksGet_593969(name: "disksGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/disks/{DiskId}",
                                  validator: validate_DisksGet_593970, base: "",
                                  url: url_DisksGet_593971,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
