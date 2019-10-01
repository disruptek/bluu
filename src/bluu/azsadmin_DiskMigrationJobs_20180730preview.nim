
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

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-DiskMigrationJobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiskMigrationJobsList_574664 = ref object of OpenApiRestCall_574442
proc url_DiskMigrationJobsList_574666(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/diskmigrationjobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiskMigrationJobsList_574665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of disk migration jobs.
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
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  var valid_574827 = path.getOrDefault("location")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "location", valid_574827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   status: JString
  ##         : The parameters of disk migration job status.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  var valid_574842 = query.getOrDefault("status")
  valid_574842 = validateParameter(valid_574842, JString, required = false,
                                 default = nil)
  if valid_574842 != nil:
    section.add "status", valid_574842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574869: Call_DiskMigrationJobsList_574664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of disk migration jobs.
  ## 
  let valid = call_574869.validator(path, query, header, formData, body)
  let scheme = call_574869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574869.url(scheme.get, call_574869.host, call_574869.base,
                         call_574869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574869, url, valid)

proc call*(call_574940: Call_DiskMigrationJobsList_574664; subscriptionId: string;
          location: string; apiVersion: string = "2018-07-30-preview";
          status: string = ""): Recallable =
  ## diskMigrationJobsList
  ## Returns a list of disk migration jobs.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   status: string
  ##         : The parameters of disk migration job status.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_574941 = newJObject()
  var query_574943 = newJObject()
  add(query_574943, "api-version", newJString(apiVersion))
  add(path_574941, "subscriptionId", newJString(subscriptionId))
  add(query_574943, "status", newJString(status))
  add(path_574941, "location", newJString(location))
  result = call_574940.call(path_574941, query_574943, nil, nil, nil)

var diskMigrationJobsList* = Call_DiskMigrationJobsList_574664(
    name: "diskMigrationJobsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/diskmigrationjobs",
    validator: validate_DiskMigrationJobsList_574665, base: "",
    url: url_DiskMigrationJobsList_574666, schemes: {Scheme.Https})
type
  Call_DiskMigrationJobsCreate_574993 = ref object of OpenApiRestCall_574442
proc url_DiskMigrationJobsCreate_574995(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "migrationId" in path, "`migrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/diskmigrationjobs/"),
               (kind: VariableSegment, value: "migrationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiskMigrationJobsCreate_574994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a disk migration job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   migrationId: JString (required)
  ##              : The migration job guid name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574996 = path.getOrDefault("subscriptionId")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "subscriptionId", valid_574996
  var valid_574997 = path.getOrDefault("location")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "location", valid_574997
  var valid_574998 = path.getOrDefault("migrationId")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "migrationId", valid_574998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   targetShare: JString (required)
  ##              : The target share name.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574999 = query.getOrDefault("api-version")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_574999 != nil:
    section.add "api-version", valid_574999
  var valid_575000 = query.getOrDefault("targetShare")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "targetShare", valid_575000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disks: JArray (required)
  ##        : The parameters of disk list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575002: Call_DiskMigrationJobsCreate_574993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a disk migration job.
  ## 
  let valid = call_575002.validator(path, query, header, formData, body)
  let scheme = call_575002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575002.url(scheme.get, call_575002.host, call_575002.base,
                         call_575002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575002, url, valid)

proc call*(call_575003: Call_DiskMigrationJobsCreate_574993;
          subscriptionId: string; disks: JsonNode; targetShare: string;
          location: string; migrationId: string;
          apiVersion: string = "2018-07-30-preview"): Recallable =
  ## diskMigrationJobsCreate
  ## Create a disk migration job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   disks: JArray (required)
  ##        : The parameters of disk list.
  ##   targetShare: string (required)
  ##              : The target share name.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   migrationId: string (required)
  ##              : The migration job guid name.
  var path_575004 = newJObject()
  var query_575005 = newJObject()
  var body_575006 = newJObject()
  add(query_575005, "api-version", newJString(apiVersion))
  add(path_575004, "subscriptionId", newJString(subscriptionId))
  if disks != nil:
    body_575006 = disks
  add(query_575005, "targetShare", newJString(targetShare))
  add(path_575004, "location", newJString(location))
  add(path_575004, "migrationId", newJString(migrationId))
  result = call_575003.call(path_575004, query_575005, nil, nil, body_575006)

var diskMigrationJobsCreate* = Call_DiskMigrationJobsCreate_574993(
    name: "diskMigrationJobsCreate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/diskmigrationjobs/{migrationId}",
    validator: validate_DiskMigrationJobsCreate_574994, base: "",
    url: url_DiskMigrationJobsCreate_574995, schemes: {Scheme.Https})
type
  Call_DiskMigrationJobsGet_574982 = ref object of OpenApiRestCall_574442
proc url_DiskMigrationJobsGet_574984(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "migrationId" in path, "`migrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/diskmigrationjobs/"),
               (kind: VariableSegment, value: "migrationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiskMigrationJobsGet_574983(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested disk migration job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   migrationId: JString (required)
  ##              : The migration job guid name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574985 = path.getOrDefault("subscriptionId")
  valid_574985 = validateParameter(valid_574985, JString, required = true,
                                 default = nil)
  if valid_574985 != nil:
    section.add "subscriptionId", valid_574985
  var valid_574986 = path.getOrDefault("location")
  valid_574986 = validateParameter(valid_574986, JString, required = true,
                                 default = nil)
  if valid_574986 != nil:
    section.add "location", valid_574986
  var valid_574987 = path.getOrDefault("migrationId")
  valid_574987 = validateParameter(valid_574987, JString, required = true,
                                 default = nil)
  if valid_574987 != nil:
    section.add "migrationId", valid_574987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574988 = query.getOrDefault("api-version")
  valid_574988 = validateParameter(valid_574988, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_574988 != nil:
    section.add "api-version", valid_574988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574989: Call_DiskMigrationJobsGet_574982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested disk migration job.
  ## 
  let valid = call_574989.validator(path, query, header, formData, body)
  let scheme = call_574989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574989.url(scheme.get, call_574989.host, call_574989.base,
                         call_574989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574989, url, valid)

proc call*(call_574990: Call_DiskMigrationJobsGet_574982; subscriptionId: string;
          location: string; migrationId: string;
          apiVersion: string = "2018-07-30-preview"): Recallable =
  ## diskMigrationJobsGet
  ## Returns the requested disk migration job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   migrationId: string (required)
  ##              : The migration job guid name.
  var path_574991 = newJObject()
  var query_574992 = newJObject()
  add(query_574992, "api-version", newJString(apiVersion))
  add(path_574991, "subscriptionId", newJString(subscriptionId))
  add(path_574991, "location", newJString(location))
  add(path_574991, "migrationId", newJString(migrationId))
  result = call_574990.call(path_574991, query_574992, nil, nil, nil)

var diskMigrationJobsGet* = Call_DiskMigrationJobsGet_574982(
    name: "diskMigrationJobsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/diskmigrationjobs/{migrationId}",
    validator: validate_DiskMigrationJobsGet_574983, base: "",
    url: url_DiskMigrationJobsGet_574984, schemes: {Scheme.Https})
type
  Call_DiskMigrationJobsCancel_575007 = ref object of OpenApiRestCall_574442
proc url_DiskMigrationJobsCancel_575009(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "migrationId" in path, "`migrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/diskmigrationjobs/"),
               (kind: VariableSegment, value: "migrationId"),
               (kind: ConstantSegment, value: "/Cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiskMigrationJobsCancel_575008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel a disk migration job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   migrationId: JString (required)
  ##              : The migration job guid name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575010 = path.getOrDefault("subscriptionId")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "subscriptionId", valid_575010
  var valid_575011 = path.getOrDefault("location")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "location", valid_575011
  var valid_575012 = path.getOrDefault("migrationId")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "migrationId", valid_575012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575013 = query.getOrDefault("api-version")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = newJString("2018-07-30-preview"))
  if valid_575013 != nil:
    section.add "api-version", valid_575013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575014: Call_DiskMigrationJobsCancel_575007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a disk migration job.
  ## 
  let valid = call_575014.validator(path, query, header, formData, body)
  let scheme = call_575014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575014.url(scheme.get, call_575014.host, call_575014.base,
                         call_575014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575014, url, valid)

proc call*(call_575015: Call_DiskMigrationJobsCancel_575007;
          subscriptionId: string; location: string; migrationId: string;
          apiVersion: string = "2018-07-30-preview"): Recallable =
  ## diskMigrationJobsCancel
  ## Cancel a disk migration job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   migrationId: string (required)
  ##              : The migration job guid name.
  var path_575016 = newJObject()
  var query_575017 = newJObject()
  add(query_575017, "api-version", newJString(apiVersion))
  add(path_575016, "subscriptionId", newJString(subscriptionId))
  add(path_575016, "location", newJString(location))
  add(path_575016, "migrationId", newJString(migrationId))
  result = call_575015.call(path_575016, query_575017, nil, nil, nil)

var diskMigrationJobsCancel* = Call_DiskMigrationJobsCancel_575007(
    name: "diskMigrationJobsCancel", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/diskmigrationjobs/{migrationId}/Cancel",
    validator: validate_DiskMigrationJobsCancel_575008, base: "",
    url: url_DiskMigrationJobsCancel_575009, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
