
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Disks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DisksList_574680 = ref object of OpenApiRestCall_574458
proc url_DisksList_574682(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksList_574681(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574842 = path.getOrDefault("subscriptionId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "subscriptionId", valid_574842
  var valid_574843 = path.getOrDefault("location")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "location", valid_574843
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
  var valid_574844 = query.getOrDefault("sharePath")
  valid_574844 = validateParameter(valid_574844, JString, required = false,
                                 default = nil)
  if valid_574844 != nil:
    section.add "sharePath", valid_574844
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574858 = query.getOrDefault("api-version")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_574858 != nil:
    section.add "api-version", valid_574858
  var valid_574859 = query.getOrDefault("userSubscriptionId")
  valid_574859 = validateParameter(valid_574859, JString, required = false,
                                 default = nil)
  if valid_574859 != nil:
    section.add "userSubscriptionId", valid_574859
  var valid_574860 = query.getOrDefault("status")
  valid_574860 = validateParameter(valid_574860, JString, required = false,
                                 default = nil)
  if valid_574860 != nil:
    section.add "status", valid_574860
  var valid_574861 = query.getOrDefault("count")
  valid_574861 = validateParameter(valid_574861, JInt, required = false, default = nil)
  if valid_574861 != nil:
    section.add "count", valid_574861
  var valid_574862 = query.getOrDefault("start")
  valid_574862 = validateParameter(valid_574862, JInt, required = false, default = nil)
  if valid_574862 != nil:
    section.add "start", valid_574862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574889: Call_DisksList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of disks.
  ## 
  let valid = call_574889.validator(path, query, header, formData, body)
  let scheme = call_574889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574889.url(scheme.get, call_574889.host, call_574889.base,
                         call_574889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574889, url, valid)

proc call*(call_574960: Call_DisksList_574680; subscriptionId: string;
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
  var path_574961 = newJObject()
  var query_574963 = newJObject()
  add(query_574963, "sharePath", newJString(sharePath))
  add(query_574963, "api-version", newJString(apiVersion))
  add(query_574963, "userSubscriptionId", newJString(userSubscriptionId))
  add(path_574961, "subscriptionId", newJString(subscriptionId))
  add(query_574963, "status", newJString(status))
  add(query_574963, "count", newJInt(count))
  add(path_574961, "location", newJString(location))
  add(query_574963, "start", newJInt(start))
  result = call_574960.call(path_574961, query_574963, nil, nil, nil)

var disksList* = Call_DisksList_574680(name: "disksList", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/disks",
                                    validator: validate_DisksList_574681,
                                    base: "", url: url_DisksList_574682,
                                    schemes: {Scheme.Https})
type
  Call_DisksGet_575002 = ref object of OpenApiRestCall_574458
proc url_DisksGet_575004(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksGet_575003(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575005 = path.getOrDefault("subscriptionId")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "subscriptionId", valid_575005
  var valid_575006 = path.getOrDefault("location")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "location", valid_575006
  var valid_575007 = path.getOrDefault("DiskId")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "DiskId", valid_575007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575008 = query.getOrDefault("api-version")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_575008 != nil:
    section.add "api-version", valid_575008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575009: Call_DisksGet_575002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the disk.
  ## 
  let valid = call_575009.validator(path, query, header, formData, body)
  let scheme = call_575009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575009.url(scheme.get, call_575009.host, call_575009.base,
                         call_575009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575009, url, valid)

proc call*(call_575010: Call_DisksGet_575002; subscriptionId: string;
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
  var path_575011 = newJObject()
  var query_575012 = newJObject()
  add(query_575012, "api-version", newJString(apiVersion))
  add(path_575011, "subscriptionId", newJString(subscriptionId))
  add(path_575011, "location", newJString(location))
  add(path_575011, "DiskId", newJString(DiskId))
  result = call_575010.call(path_575011, query_575012, nil, nil, nil)

var disksGet* = Call_DisksGet_575002(name: "disksGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/disks/{DiskId}",
                                  validator: validate_DisksGet_575003, base: "",
                                  url: url_DisksGet_575004,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
