
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: InstanceMetadataClient
## version: 2019-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Instance Metadata Client
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "imds"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GalleryApplicationsList_593630 = ref object of OpenApiRestCall_593408
proc url_GalleryApplicationsList_593632(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GalleryApplicationsList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get list of the gallery applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593804 = query.getOrDefault("api-version")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593804 != nil:
    section.add "api-version", valid_593804
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593805 = header.getOrDefault("Metadata")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = newJString("true"))
  if valid_593805 != nil:
    section.add "Metadata", valid_593805
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593828: Call_GalleryApplicationsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get list of the gallery applications.
  ## 
  let valid = call_593828.validator(path, query, header, formData, body)
  let scheme = call_593828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593828.url(scheme.get, call_593828.host, call_593828.base,
                         call_593828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593828, url, valid)

proc call*(call_593899: Call_GalleryApplicationsList_593630;
          apiVersion: string = "2018-10-01"): Recallable =
  ## galleryApplicationsList
  ## Get list of the gallery applications.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_593900 = newJObject()
  add(query_593900, "api-version", newJString(apiVersion))
  result = call_593899.call(nil, query_593900, nil, nil, nil)

var galleryApplicationsList* = Call_GalleryApplicationsList_593630(
    name: "galleryApplicationsList", meth: HttpMethod.HttpGet,
    host: "169.254.169.254", route: "/applications",
    validator: validate_GalleryApplicationsList_593631, base: "/metadata",
    url: url_GalleryApplicationsList_593632, schemes: {Scheme.Https})
type
  Call_GalleryApplicationGet_593940 = ref object of OpenApiRestCall_593408
proc url_GalleryApplicationGet_593942(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GalleryApplicationGet_593941(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get application package.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   incarnationId: JString (required)
  ##                : Incarnation Id of the gallery application
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593943 = query.getOrDefault("api-version")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593943 != nil:
    section.add "api-version", valid_593943
  var valid_593944 = query.getOrDefault("incarnationId")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "incarnationId", valid_593944
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593945 = header.getOrDefault("Metadata")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = newJString("true"))
  if valid_593945 != nil:
    section.add "Metadata", valid_593945
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593946: Call_GalleryApplicationGet_593940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application package.
  ## 
  let valid = call_593946.validator(path, query, header, formData, body)
  let scheme = call_593946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593946.url(scheme.get, call_593946.host, call_593946.base,
                         call_593946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593946, url, valid)

proc call*(call_593947: Call_GalleryApplicationGet_593940; incarnationId: string;
          apiVersion: string = "2018-10-01"): Recallable =
  ## galleryApplicationGet
  ## Get application package.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   incarnationId: string (required)
  ##                : Incarnation Id of the gallery application
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(query_593948, "incarnationId", newJString(incarnationId))
  result = call_593947.call(nil, query_593948, nil, nil, nil)

var galleryApplicationGet* = Call_GalleryApplicationGet_593940(
    name: "galleryApplicationGet", meth: HttpMethod.HttpGet,
    host: "169.254.169.254", route: "/applications/app",
    validator: validate_GalleryApplicationGet_593941, base: "/metadata",
    url: url_GalleryApplicationGet_593942, schemes: {Scheme.Https})
type
  Call_AttestedGetDocument_593949 = ref object of OpenApiRestCall_593408
proc url_AttestedGetDocument_593951(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AttestedGetDocument_593950(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get Attested Data for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   nonce: JString
  ##        : This is a string of up to 32 random alphanumeric characters.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593952 = query.getOrDefault("api-version")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593952 != nil:
    section.add "api-version", valid_593952
  var valid_593953 = query.getOrDefault("nonce")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "nonce", valid_593953
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593954 = header.getOrDefault("Metadata")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = newJString("true"))
  if valid_593954 != nil:
    section.add "Metadata", valid_593954
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593955: Call_AttestedGetDocument_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Attested Data for the Virtual Machine.
  ## 
  let valid = call_593955.validator(path, query, header, formData, body)
  let scheme = call_593955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593955.url(scheme.get, call_593955.host, call_593955.base,
                         call_593955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593955, url, valid)

proc call*(call_593956: Call_AttestedGetDocument_593949;
          apiVersion: string = "2018-10-01"; nonce: string = ""): Recallable =
  ## attestedGetDocument
  ## Get Attested Data for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   nonce: string
  ##        : This is a string of up to 32 random alphanumeric characters.
  var query_593957 = newJObject()
  add(query_593957, "api-version", newJString(apiVersion))
  add(query_593957, "nonce", newJString(nonce))
  result = call_593956.call(nil, query_593957, nil, nil, nil)

var attestedGetDocument* = Call_AttestedGetDocument_593949(
    name: "attestedGetDocument", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/attested/document", validator: validate_AttestedGetDocument_593950,
    base: "/metadata", url: url_AttestedGetDocument_593951, schemes: {Scheme.Https})
type
  Call_IdentityGetInfo_593958 = ref object of OpenApiRestCall_593408
proc url_IdentityGetInfo_593960(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetInfo_593959(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get information about AAD Metadata
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593962 = header.getOrDefault("Metadata")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = newJString("true"))
  if valid_593962 != nil:
    section.add "Metadata", valid_593962
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593963: Call_IdentityGetInfo_593958; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about AAD Metadata
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_IdentityGetInfo_593958;
          apiVersion: string = "2018-10-01"): Recallable =
  ## identityGetInfo
  ## Get information about AAD Metadata
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  result = call_593964.call(nil, query_593965, nil, nil, nil)

var identityGetInfo* = Call_IdentityGetInfo_593958(name: "identityGetInfo",
    meth: HttpMethod.HttpGet, host: "169.254.169.254", route: "/identity/info",
    validator: validate_IdentityGetInfo_593959, base: "/metadata",
    url: url_IdentityGetInfo_593960, schemes: {Scheme.Https})
type
  Call_IdentityGetToken_593966 = ref object of OpenApiRestCall_593408
proc url_IdentityGetToken_593968(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetToken_593967(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a Token from Azure AD
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   object_id: JString
  ##            : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   client_id: JString
  ##            : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   resource: JString (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypass_cache: JString
  ##               : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: JString
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msi_res_id: JString
  ##             : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  section = newJObject()
  var valid_593969 = query.getOrDefault("object_id")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "object_id", valid_593969
  var valid_593970 = query.getOrDefault("client_id")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "client_id", valid_593970
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  var valid_593972 = query.getOrDefault("resource")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resource", valid_593972
  var valid_593973 = query.getOrDefault("bypass_cache")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = newJString("true"))
  if valid_593973 != nil:
    section.add "bypass_cache", valid_593973
  var valid_593974 = query.getOrDefault("authority")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "authority", valid_593974
  var valid_593975 = query.getOrDefault("msi_res_id")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "msi_res_id", valid_593975
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593976 = header.getOrDefault("Metadata")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = newJString("true"))
  if valid_593976 != nil:
    section.add "Metadata", valid_593976
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_IdentityGetToken_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Token from Azure AD
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_IdentityGetToken_593966; resource: string;
          objectId: string = ""; clientId: string = "";
          apiVersion: string = "2018-10-01"; bypassCache: string = "true";
          authority: string = ""; msiResId: string = ""): Recallable =
  ## identityGetToken
  ## Get a Token from Azure AD
  ##   objectId: string
  ##           : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   clientId: string
  ##           : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   resource: string (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypassCache: string
  ##              : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: string
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msiResId: string
  ##           : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  var query_593979 = newJObject()
  add(query_593979, "object_id", newJString(objectId))
  add(query_593979, "client_id", newJString(clientId))
  add(query_593979, "api-version", newJString(apiVersion))
  add(query_593979, "resource", newJString(resource))
  add(query_593979, "bypass_cache", newJString(bypassCache))
  add(query_593979, "authority", newJString(authority))
  add(query_593979, "msi_res_id", newJString(msiResId))
  result = call_593978.call(nil, query_593979, nil, nil, nil)

var identityGetToken* = Call_IdentityGetToken_593966(name: "identityGetToken",
    meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/identity/oauth2/token", validator: validate_IdentityGetToken_593967,
    base: "/metadata", url: url_IdentityGetToken_593968, schemes: {Scheme.Https})
type
  Call_InstancesGetMetadata_593980 = ref object of OpenApiRestCall_593408
proc url_InstancesGetMetadata_593982(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InstancesGetMetadata_593981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593984 = header.getOrDefault("Metadata")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = newJString("true"))
  if valid_593984 != nil:
    section.add "Metadata", valid_593984
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_InstancesGetMetadata_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_InstancesGetMetadata_593980;
          apiVersion: string = "2018-10-01"): Recallable =
  ## instancesGetMetadata
  ## Get Instance Metadata for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_593987 = newJObject()
  add(query_593987, "api-version", newJString(apiVersion))
  result = call_593986.call(nil, query_593987, nil, nil, nil)

var instancesGetMetadata* = Call_InstancesGetMetadata_593980(
    name: "instancesGetMetadata", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/instance", validator: validate_InstancesGetMetadata_593981,
    base: "/metadata", url: url_InstancesGetMetadata_593982, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
